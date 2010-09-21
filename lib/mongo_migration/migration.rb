module Mongo
  class Migration
    class << self
      def migrate(direction)
        return unless respond_to?(direction)

        puts "migrating #{direction}"
        send direction
      end

      def connection
        Mongo::Connection.new(configuration.db_host, configuration.db_port)
      end

      def db
        connection.db(configuration.db_name)
      end

      attr_accessor :configuration

      # Configure Mongo::Migration someplace sensible,
      # like config/initializers/mongo_migration.rb
      #
      # @example
      #   Mongo::Migration.configure do |config|
      #     config.migrations_path = 'db/mongo_migrate/'
      #
      #     mongoid_config = YAML::load('/config/mongoid.yml')[Rails.env].symbolize_keys
      #
      #     config.db_name = mongoid_config[:database]
      #     config.db_host = mongoid_config[:host]
      #     config.db_port = mongoid_config[:port]
      #   end
      def configure
        configuration ||= Mongo::Configuration.new
        yield(configuration)
      end
    end
  end

  class Configuration
    attr_accessor :migrations_path, :db_name, :db_host, :db_port

    def initialize
      @migrations_path = 'db/mongo_migrate/'
      @db_host         = 'localhost'
      @db_port         = 27017
    end
  end
end
