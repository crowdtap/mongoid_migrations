module Mongo
  class MongoError < StandardError; end

  class DuplicateMigrationVersionError < MongoError#:nodoc:
    def initialize(version)
      super "Multiple migrations have the version number #{version}"
    end
  end

  class DuplicateMigrationNameError < MongoError#:nodoc:
    def initialize(name)
      super "Multiple migrations have the name #{name}"
    end
  end

  class UnknownMigrationVersionError < MongoError #:nodoc:
    def initialize(version)
      super "No migration with version number #{version}"
    end
  end

  class IllegalMigrationNameError < MongoError#:nodoc:
    def initialize(name)
      super "Illegal name for migration file: #{name}"
    end
  end
end
