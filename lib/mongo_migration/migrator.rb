module Mongo
  class Migrator#:nodoc:
    def initialize(options = {})
      @version = options[:version]
      @steps   = options[:steps]
    end

    def migrate_up
      upward_migration_filenames.each do |filename|
        migration_class_from(filename).new.migrate(:up)
      end
    end

    def migration_filenames
      @migration_filenames ||= Dir["db/mongo_migrate/[0-9]*_*.rb"]
    end

    def migration_class_from(filename)
      version, name = filename.scan(/([0-9]+)_([_a-z0-9]*).rb/).first
      name.camelize.constantize
    end
  end
end
