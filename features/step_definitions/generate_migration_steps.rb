Given /^I have a new rails app$/ do
  generate_rails_app
end

When /^I generate a migration$/ do
  generate_migration('test_migration')
end

When /^I generate a migration again$/ do
  lambda{
    generate_migration('test_migration')
  }.should raise_error SystemExit
end

Then /^I should see a message that the migration already exists$/ do
  @std_output.should include "Another migration is already named test_migration"
end


When /^I call generate without parameters$/ do
  lambda{
    generate_migration(nil)
  }.should raise_error SystemExit
end

Then /^I should see the usage help$/ do
  @std_output.should include "./script/generate mongoid_migration MigrationName [options]"
end


Then /^I gets$/ do
  puts "ENTER to continue"
  gets
end


Then /^the migration should have proper content$/ do
  contents = File.read(Dir["#{@app_root}/db/mongoid_migrate/*"].first)
  contents.should include "TestMigration"
end

Then /^I should have a new migration file$/ do
  res =  Dir["#{@app_root}/db/mongoid_migrate/*"]
  res.size.should == 1
  File.basename(res.first).should match /[0-9]*_test_migration.rb/
end

