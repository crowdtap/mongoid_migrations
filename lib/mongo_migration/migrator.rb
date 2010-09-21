module Mongo
  class Migrator#:nodoc:
    def initialize(options = {})
      @version = options[:version]
      @steps   = options[:steps]
    end

    def migrate_up

    end

    def run
      target = migrations.detect { |m| m.version == @version }
      raise UnknownMigrationVersionError.new(@version) if target.nil?
      unless (up? && migrated.include?(target.version.to_i)) || (down? && !migrated.include?(target.version.to_i))
        target.migrate(@direction)
        record_version_state_after_migrating(target.version)
      end
    end

    def migrate
      runnable.each do |migration|
        Rails.logger.info "Migrating to #{migration.name} (#{migration.version})"

        # On our way up, we skip migrating the ones we've already migrated
        next if up? && migrated.include?(migration.version.to_i)

        # On our way down, we skip reverting the ones we've never migrated
        if down? && !migrated.include?(migration.version.to_i)
          migration.announce 'never migrated, skipping'; migration.write
          next
        end

        begin
          migration.migrate(@direction)
          record_version_state_after_migrating(migration.version)
        rescue => e
          raise StandardError, "An error has occurred, all later migrations canceled:\n\n#{e}", e.backtrace
        end
      end
    end

    def migrations
      @migrations ||= begin
        files = Dir["#{@migrations_path}/[0-9]*_*.rb"]

        migrations = files.inject([]) do |klasses, file|
          version, name = file.scan(/([0-9]+)_([_a-z0-9]*).rb/).first

          raise IllegalMigrationNameError.new(file) unless version
          version = version.to_i

          if klasses.detect { |m| m.version == version }
            raise DuplicateMigrationVersionError.new(version)
          end

          if klasses.detect { |m| m.name == name.camelize }
            raise DuplicateMigrationNameError.new(name.camelize)
          end

          klasses << returning(MigrationProxy.new) do |migration|
            migration.name     = name.camelize
            migration.version  = version
            migration.filename = file
          end
        end

        migrations = migrations.sort_by(&:version)
        down? ? migrations.reverse : migrations
      end
    end
  end
end
