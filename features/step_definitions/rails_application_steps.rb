Given /^I generate a Rails application with mongo migrations$/ do
  steps %{
    When I generate a Rails application
    And I setup my Rails 2.3 app with Bundler
    And I generate a Gemfile with mongo migration gem
    And I run "bundle install"
    And cleanup Mongo
  }
end

When /^I generate a Rails application$/ do
  @terminal.cd   TEMP_DIR
  @terminal.run 'rails rails_root'
end

When /^I generate a Gemfile with mongo migration gem$/ do
  @terminal.cd RAILS_ROOT
  FileUtils.cp File.join(PROJECT_ROOT, 'features', 'support', 'fixtures', 'Gemfile'), RAILS_ROOT
end

When /^I setup my Rails 2.3 app with Bundler$/ do
  require_bundler_in_boot_rb
  create_preinitializer
end

And /^cleanup Mongo$/ do
  drop_collections
end

When /^I run the mongo migration generator with "([^\"]*)"$/ do |generator_args|
  When %{I run "bundle exec script/generate mongo_migration #{generator_args}"}
end

When /^I run "([^\"]*)"$/ do |command|
  @terminal.cd  RAILS_ROOT
  @terminal.run command
end

Then /^I should see "([^\"]*)"$/ do |expected_text|
  unless @terminal.output.include?(expected_text)
    raise("Got terminal output:\n#{@terminal.output}\n\nExpected output:\n#{expected_text}")
  end
end

Then /^I should not see "([^\"]*)"$/ do |unexpected_text|
  if @terminal.output.include?(unexpected_text)
    raise("Got terminal output:\n#{@terminal.output}\n\nDid not expect the following output:\n#{unexpected_text}")
  end
end
