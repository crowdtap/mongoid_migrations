namespace :mongo do
  namespace :migrate do
    desc  'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x. Target specific version with VERSION=x.'
    task :redo => :environment do
      Rake::Task["mongo:rollback"].invoke
      Rake::Task["mongo:migrate"].invoke
    end

    desc 'Runs the "up" for a given migration VERSION.'
    task :up => :environment do
      migrator = Mongo::Migrator.new(:version => ENV["VERSION"])
      migrator.migrate_up
    end

    desc 'Runs the "down" for a given migration VERSION.'
    task :down => :environment do
      migrator = Mongo::Migrator.new(:version => ENV["VERSION"])
      migrator.migrate_down
    end
  end

  desc "Migrate the database through scripts in db/mongo_migrate. Target specific version with VERSION=x."
  task :migrate => :environment do
    migrator = Mongo::Migrator.new(:version => ENV["VERSION"])
    migrator.migrate_up
  end

  desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
  task :rollback => :environment do
    migrator = Mongo::Migrator.new(:version => ENV["VERSION"], :steps => ENV["STEP"])
    migrator.migrate_down
  end

  desc "Raises an error if there are pending migrations"
  task :abort_if_pending_migrations => :environment do
    if defined?(Mongo)
      pending_migrations = Mongo::Migrator.up('db/mongo_migrate').pending_migrations

      if pending_migrations.any?
        puts "You have #{pending_migrations.size} pending migrations:"
        pending_migrations.each do |pending_migration|
          puts '  %4d %s' % [pending_migration.version, pending_migration.name]
        end
        abort %{Run "rake mongo:migrate" to update your database then try again.}
      end
    end
  end
end
