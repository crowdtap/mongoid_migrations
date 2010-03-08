class MongoidMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory File.join('db/mongoid_migrate')
      @file_name = @args.first
      migration_file_name = "#{next_migration_version}_#{@file_name}"

      if migration_exists?(migration_file_name)
        raise "Another migration is already named #{migration_file_name}: #{existing_migrations(migration_file_name).first}" 
      end
      m.template 'migration.rb', "db/mongoid_migrate/#{migration_file_name}.rb", :assigns => {:class_name => @file_name}
    end
  end

  def next_migration_version
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def existing_migrations(file_name)
    Dir.glob("db/mongoid_migrate/[0-9]*_*.rb").grep(/[0-9]+_#{file_name}.rb$/)
  end


  def migration_exists?(file_name)
    not existing_migrations(file_name).empty?
  end

end
