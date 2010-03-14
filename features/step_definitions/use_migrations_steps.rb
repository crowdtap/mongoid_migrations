Given /^I have (\d+) pending migrations$/ do |how_many|
  how_many.to_i.times do |i|
    generate_migration("test_migration_#{i}")
    fname = Dir["#{@app_root}/db/mongoid_migrate/*_test_migration_#{i}.rb"].first
    prefix = (Time.now.utc.strftime("%Y%m%d%H%M%S").to_i+i*1000).to_s
    new_fname = "#{@app_root}/db/mongoid_migrate/" << prefix << "_" << fname.match(/[\d+]_(.*)/)[1]
    File.rename(fname,new_fname)

    content = File.read(new_fname)
    content.gsub!('def self.up',%Q{
      def self.up
        Mongoid.database["test_migration_#{i}"].insert({:migration_name => "test_migration_#{i}"})
    })
    content.gsub!('def self.down',%Q{
      def self.down
        Mongoid.database["test_migration_#{i}"].drop
    })
    File.open(new_fname, 'w') {|f| f.write(content) }
  end
end

When /^I run the migrate task$/ do
  Rails.stub!(:logger).and_return(Logger.new($stdout))
  capture_output {
    Mongoid::Migrator.migrate("#{@app_root}/db/mongoid_migrate/")
  }
end

Then /^I should see "([^\"]*)" in the stdout$/ do |arg1|
  @std_output.should include(arg1)
end

Then /^I should have the proper collections and records in the database$/ do
  Mongoid.database.collection_names.should include("test_migration_0")
  Mongoid.database.collection_names.should include("test_migration_1")
  rec = Mongoid.database['test_migration_0'].find_one
  rec['migration_name'].should == 'test_migration_0'

  rec = Mongoid.database['test_migration_1'].find_one
  rec['migration_name'].should == 'test_migration_1'
end


Then /^my database should have 0 pending migrations$/ do
  pending_migrations = Mongoid::Migrator.new(:up, 'db/mongoid_migrate').pending_migrations
  pending_migrations.should be_empty
end


Given /^I have 2 migrated migrations$/ do
  Given "I have 2 pending migrations"
  Then "I run the migrate task"
end

When /^I rollback my last migration$/ do
  capture_output {
    Mongoid::Migrator.rollback("#{@app_root}/db/mongoid_migrate/", 1)
  }
end

Then /^my database should have 1 pending migrations$/ do
  pending_migrations = Mongoid::Migrator.new(:up, "#{@app_root}/db/mongoid_migrate/").pending_migrations
  pending_migrations.size.should == 1
end

Then /^the down step of the removed migration should have executed$/ do
  Mongoid.database.collection_names.should include("test_migration_0")
  Mongoid.database.collection_names.should_not include("test_migration_1")
  rec = Mongoid.database['test_migration_0'].find_one
  rec['migration_name'].should == 'test_migration_0'
end
