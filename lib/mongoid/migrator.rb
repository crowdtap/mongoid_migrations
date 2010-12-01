module Mongoid

  class Migrator#:nodoc:
    class << self
      def migrate(migrations_path, target_version = nil)
        case
          when target_version.nil?              then up(migrations_path, target_version)
          when current_version > target_version then down(migrations_path, target_version)
          else                                       up(migrations_path, target_version)
        end
      end

      def rollback(migrations_path, steps=1)
        migrator = self.new(:down, migrations_path)
        start_index = migrator.migrations.index(migrator.current_migration)

        return unless start_index

        finish = migrator.migrations[start_index + steps]
        down(migrations_path, finish ? finish.version : 0)
      end

      def up(migrations_path, target_version = nil)
        self.new(:up, migrations_path, target_version).migrate
      end

      def down(migrations_path, target_version = nil)
        self.new(:down, migrations_path, target_version).migrate
      end

      def run(direction, migrations_path, target_version)
        self.new(direction, migrations_path, target_version).run
      end

      def get_all_versions
        Mongoid.database["migrations"].find.map{|r| r['version'].to_i}.sort
      end

      def current_version
        get_all_versions.max || 0
      end

    end

    def initialize(direction, migrations_path, target_version = nil)
      @direction, @migrations_path, @target_version = direction, migrations_path, target_version
    end

    def current_version
      migrated.last || 0
    end

    def current_migration
      migrations.detect { |m| m.version == current_version }
    end

    def run
      target = migrations.detect { |m| m.version == @target_version }
      raise UnknownMigrationVersionError.new(@target_version) if target.nil?
      unless (up? && migrated.include?(target.version.to_i)) || (down? && !migrated.include?(target.version.to_i))
        target.migrate(@direction)
        record_version_state_after_migrating(target.version)
      end
    end

    def migrate
      current = migrations.detect { |m| m.version == current_version }
      target = migrations.detect { |m| m.version == @target_version }

      if target.nil? && !@target_version.nil? && @target_version > 0
        raise UnknownMigrationVersionError.new(@target_version)
      end

      start = up? ? 0 : (migrations.index(current) || 0)
      finish = migrations.index(target) || migrations.size - 1
      runnable = migrations[start..finish]
      # skip the last migration if we're headed down, but not ALL the way down
      runnable.pop if down? && !target.nil?

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

          klasses << MigrationProxy.new.tap do |migration|
            migration.name     = name.camelize
            migration.version  = version
            migration.filename = file
          end
        end

        migrations = migrations.sort_by(&:version)
        down? ? migrations.reverse : migrations
      end
    end

    def pending_migrations
      already_migrated = migrated
      migrations.reject { |m| already_migrated.include?(m.version.to_i) }
    end

    def migrated
      @migrated_versions ||= self.class.get_all_versions
    end

    private
      def record_version_state_after_migrating(version)
        @migrated_versions ||= []
        if down?
          @migrated_versions.delete(version.to_i)
          Mongoid.database["migrations"].remove({:version => version.to_i})
        else
          @migrated_versions.push(version.to_i).sort!
          Mongoid.database["migrations"].insert({:version => version.to_i})
        end
      end

      def up?
        @direction == :up
      end

      def down?
        @direction == :down
      end
  end
end
