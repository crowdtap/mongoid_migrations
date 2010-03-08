Gem::Specification.new do |s|
  s.name     = "mongoid_migration"
  s.version  = "0.1"
  s.date     = "2009-03-07"
  s.summary  = "Mongoid Migrations in Rails"
  s.email    = "gyordanov@gmail.com"
  s.homepage = "http://github.com/gyordanov"
  s.description = "Mongoid Migrations in Rails"
  s.has_rdoc = false
  s.authors  = ["Galin Yordanov"]
  s.files    = ["features",
   "features/generate_migration.feature",
   "features/step_definitions",
   "features/step_definitions/generate_migration.rb",
   "features/support",
   "features/support/env.rb",
   "generators",
   "generators/mongoid_migration",
   "generators/mongoid_migration/mongoid_migration_generator.rb",
   "generators/mongoid_migration/templates",
   "generators/mongoid_migration/templates/migration.rb",
   "generators/mongoid_migration/USAGE",
   "init.rb",
   "lib",
   "lib/mongoid",
   "lib/mongoid/migration.rb",
   "lib/mongoid/migrator.rb",
   "lib/mongoid_migration.rb",
   "mongoid_migrations.gemspec",
   "Rakefile",
   "tasks",
   "tasks/mongoid_migration_tasks.rake",
   "test",
   "test/generators_test.rb",
   "test/migrator_test.rb",
   "test/test_helper.rb"]
  s.require_paths = ["lib"]
end
