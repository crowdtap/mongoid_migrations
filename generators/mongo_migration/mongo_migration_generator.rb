class MongoMigrationGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
    usage if @args.empty?
  end

  def manifest
    @migration_path = destination_path('db/mongo_migrate')
    record do |m|
      m.directory File.join('db/mongo_migrate')
      @file_name = @args.first
      migration_file_name = "#{next_migration_version}_#{@file_name}"

      if migration_exists?(@file_name)
        raise "Another migration is already named #{@file_name}: #{existing_migrations(@file_name).first}"
      end
      m.template 'migration.rb', "db/mongo_migrate/#{migration_file_name}.rb", :assigns => {:class_name => @file_name}
    end
  end

  def next_migration_version
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def existing_migrations(file_name)
    Dir.glob("#{@migration_path}/[0-9]*_*.rb").grep(/[0-9]+_#{file_name}.rb$/)
  end

  def migration_exists?(file_name)
    not existing_migrations(file_name).empty?
  end
end
