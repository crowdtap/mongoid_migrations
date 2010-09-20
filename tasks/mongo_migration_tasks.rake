namespace :mongo do
  task :load_config => :rails_env

  desc "Migrate the database through scripts in db/mongo_migrate. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
  task :migrate => :environment do
    Mongo::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    Mongo::Migrator.migrate("db/mongo_migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end

  namespace :migrate do
    desc  'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x. Target specific version with VERSION=x.'
    task :redo => :environment do
      if ENV["VERSION"]
        Rake::Task["mongo:migrate:down"].invoke
        Rake::Task["mongo:migrate:up"].invoke
      else
        Rake::Task["mongo:rollback"].invoke
        Rake::Task["mongo:migrate"].invoke
      end
    end

    desc 'Runs the "up" for a given migration VERSION.'
    task :up => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      Mongo::Migrator.run(:up, "db/mongo_migrate/", version)
    end

    desc 'Runs the "down" for a given migration VERSION.'
    task :down => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      Mongo::Migrator.run(:down, "db/mongo_migrate/", version)
    end
  end

  desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
  task :rollback => :environment do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    Mongo::Migrator.rollback('db/mongo_migrate/', step)
  end

  desc "Retrieves the current schema version number"
  task :version => :environment do
    puts "Current version: #{Mongo::Migrator.current_version}"
  end

  desc "Raises an error if there are pending migrations"
  task :abort_if_pending_migrations => :environment do
    if defined? Mongo
      pending_migrations = Mongo::Migrator.new(:up, 'db/mongo_migrate').pending_migrations

      if pending_migrations.any?
        puts "You have #{pending_migrations.size} pending migrations:"
        pending_migrations.each do |pending_migration|
          puts '  %4d %s' % [pending_migration.version, pending_migration.name]
        end
        abort %{Run "rake mongo:migrate" to update your database then try again.}
      end
    end
  end

  desc 'Migrate the database and initialize with the seed data'
  task :setup => ['mongo:migrate', 'db:seed']
end
