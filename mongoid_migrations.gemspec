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
  s.files    = [
   "features/generate_migration.feature",
   "features/step_definitions/generate_migration_steps.rb",
   "features/step_definitions/use_migrations_steps.rb",
   "features/support/env.rb",
   "features/use_migrations.feature",
   "generators/mongoid_migration/mongoid_migration_generator.rb",
   "generators/mongoid_migration/templates",
   "generators/mongoid_migration/templates/migration.rb",
   "generators/mongoid_migration/USAGE",
   "init.rb",
   "lib/mongoid/migration.rb",
   "lib/mongoid/migrator.rb",
   "lib/mongoid_migration.rb",
   "mongoid_migrations.gemspec",
   "Rakefile",
   "tasks/mongoid_migration_tasks.rake"]
  s.require_paths = ["lib"]
  s.add_dependency('mongoid')
end
