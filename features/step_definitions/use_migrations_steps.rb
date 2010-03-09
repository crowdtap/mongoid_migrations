Given /^I have (\d+) pending migrations$/ do |how_many|
  how_many.to_i.times do |i|
    generate_migration("test_migration_#{i}")
    fname = Dir["#{@app_root}/db/mongoid_migrate/*_test_migration_#{i}.rb"].first
    prefix = (Time.now.utc.strftime("%Y%m%d%H%M%S").to_i+i*1000).to_s
    new_fname = "#{@app_root}/db/mongoid_migrate/" << prefix << "_" << fname.match(/[\d+]_(.*)/)[1]
    File.rename(fname,new_fname)
  end
end

# When /^I run the migrate task$/ do
#   Mongoid::Migrator.stub!(:get_all_versions).and_return([])
#   Rails.stub!(:logger).and_return(Logger.new($stdout))
#   Mongoid::Migrator.stub!(:record_version_state_after_migrating).and_return(true)
#   Mongoid::Migrator.migrate("#{@app_root}/db/mongoid_migrate/")
# end
