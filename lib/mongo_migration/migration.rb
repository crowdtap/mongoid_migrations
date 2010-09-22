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

      def configure
        configuration ||= Mongo::Configuration.new
        yield(configuration)
      end
    end
  end

  class Configuration
    attr_accessor :db_name, :db_host, :db_port

    def initialize
      @db_host = 'localhost'
      @db_port = 27017
    end
  end
end
