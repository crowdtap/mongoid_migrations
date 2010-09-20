Given /^I have (\d+) pending migrations$/ do |how_many|
  how_many.to_i.times do |i|
    steps %{
      When I run "script/generate mongo_migration test_migration_#{i}"
    }
  end
end

Then /^my database should have 0 pending migrations$/ do
  pending_migrations = Mongo::Migrator.new(:up, 'db/mongo_migrate').pending_migrations
  pending_migrations.should be_empty
end

Then /^my database should have 1 pending migrations$/ do
  pending_migrations = Mongo::Migrator.new(:up, "#{RAILS_ROOT}/db/mongo_migrate/").pending_migrations
  pending_migrations.size.should == 1
end

Then /^the generated migration should contain "([^\"]*)"$/ do |text|
  File.read(first_migration).should include(text)
end

Then /^I should have a new migration file$/ do
  File.basename(first_migration).should match /[0-9]*_test_migration.rb/
end
