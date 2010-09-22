Given /^I generate a Rails application with mongo migrations$/ do
  steps %{
    When I generate a Rails application
    And I setup my Rails 2.3 app with Bundler
    And I run "bundle install"
    And I install the mongo migration plugin
    And I set up a mongo migration config file
    And cleanup Mongo
  }
end

When /^I generate a Rails application$/ do
  @terminal.cd   TEMP_DIR
  @terminal.run 'rails rails_root'
end

When /^I install the mongo migration plugin$/ do
  FileUtils.ln_s PROJECT_ROOT, "#{RAILS_ROOT}/vendor/plugins/mongo_migration"
end

When /^I set up a mongo migration config file$/ do
  config_file = %{
    Mongo::Migration.configure do |config|
      config.db_name = 'mongo_migration_db'
    end
  }

  path = File.join(RAILS_ROOT, 'config', 'mongo_migration.rb')
  File.open(path, 'wb') { |file| file.write(config_file) }
end
