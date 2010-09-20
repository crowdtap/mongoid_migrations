require 'mongo_migration/migration'
require 'mongo_migration/migrator'

module Mongo
  class MongoError < StandardError; end

  class IrreversibleMigration < MongoError#:nodoc:
  end

  class DuplicateMigrationVersionError < MongoError#:nodoc:
    def initialize(version)
      super("Multiple migrations have the version number #{version}")
    end
  end

  class DuplicateMigrationNameError < MongoError#:nodoc:
    def initialize(name)
      super("Multiple migrations have the name #{name}")
    end
  end

  class UnknownMigrationVersionError < MongoError #:nodoc:
    def initialize(version)
      super("No migration with version number #{version}")
    end
  end

  class IllegalMigrationNameError < MongoError#:nodoc:
    def initialize(name)
      super("Illegal name for migration file: #{name}\n\t(only lower case letters, numbers, and '_' allowed)")
    end
  end

  class MigrationProxy
    attr_accessor :name, :version, :filename

    delegate :migrate, :announce, :write, :to => :migration

    private

    def migration
      @migration ||= load_migration
    end

    def load_migration
      load(filename)
      name.constantize
    end
  end
end
