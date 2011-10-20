namespace :mongoid do
  task :load_config => :rails_env

  desc "Migrate the database through scripts in db/mongoid_migrate. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
  task :migrate => :environment do
    Mongoid::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    Mongoid::Migrator.migrate("db/mongoid_migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    Rake::Task["mongoid:snapshot"].invoke
  end

  namespace :migrate do
    desc  'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x. Target specific version with VERSION=x.'
    task :redo => :environment do
      if ENV["VERSION"]
        Rake::Task["mongoid:migrate:down"].invoke
        Rake::Task["mongoid:migrate:up"].invoke
      else
        Rake::Task["mongoid:rollback"].invoke
        Rake::Task["mongoid:migrate"].invoke
      end
    end

    desc 'Runs the "up" for a given migration VERSION.'
    task :up => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      Mongoid::Migrator.run(:up, "db/mongoid_migrate/", version)
    end

    desc 'Runs the "down" for a given migration VERSION.'
    task :down => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      Mongoid::Migrator.run(:down, "db/mongoid_migrate/", version)
    end
  end

  desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
  task :rollback => :environment do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    Mongoid::Migrator.rollback('db/mongoid_migrate/', step)
  end

  desc "Retrieves the current schema version number"
  task :version => :environment do
    puts "Current version: #{Mongoid::Migrator.current_version}"
  end

  desc "Raises an error if there are pending migrations"
  task :abort_if_pending_migrations => :environment do
    if defined? Mongoid
      pending_migrations = Mongoid::Migrator.new(:up, 'db/mongoid_migrate').pending_migrations

      if pending_migrations.any?
        puts "You have #{pending_migrations.size} pending migrations:"
        pending_migrations.each do |pending_migration|
          puts '  %4d %s' % [pending_migration.version, pending_migration.name]
        end
        abort %{Run "rake mongoid:migrate" to update your database then try again.}
      end
    end
  end

  desc 'Dumps system indexes in db/indexes'
  task :snapshot => :environment do
    `mkdir -p #{Rails.root}/db/snapshot`
    %w(system.indexes migrations).each do |collection|
      command = "mongodump -h #{Mongoid.database.connection.host} --port #{Mongoid.database.connection.port} -d #{Mongoid.database.name} -c #{collection} -o - > #{Rails.root}/db/snapshot/#{collection}.bson"
      puts command
    end
  end

  desc 'Migrate the database and initialize with the seed data'
  task :setup => [ 'mongoid:migrate', 'db:seed' ]

end
