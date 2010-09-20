Then /^I should see a message that the migration already exists$/ do
  @terminal.output.should include "Another migration is already named test_migration"
end

Then /^I should see the usage help$/ do
  @terminal.output.should include "./script/generate mongoid_migration MigrationName [options]"
end

Then /^the migration should have proper content$/ do
  File.read(first_migration).should include "TestMigration"
end

Then /^I should have a new migration file$/ do
  File.basename(first_migration).should match /[0-9]*_test_migration.rb/
end
