When /^I generate a Rails application$/ do
  @terminal.cd   TEMP_DIR
  @terminal.run 'rails rails_root'

  if rails_root_exists?
    @terminal.echo("Generated a Rails 2.3.5 application")
  else
    raise "Unable to generate a Rails application:\n#{@terminal.output}"
  end
end

Given /^I generate a Rails application with mongo migrations$/ do
  steps %{
    When I generate a Rails application
    And I generate a Gemfile with mongo migrations
    And I run "bundle install"
    And cleanup Mongo
  }
end

And /^cleanup Mongo$/ do
  drop_collections
end

When /^I generate a Gemfile with mongo migrations$/ do
  FileUtils.cp File.join(PROJECT_ROOT, 'features', 'support', 'fixtures', 'Gemfile'), RAILS_ROOT
end

When /^I run the mongo migration generator with "([^\"]*)"$/ do |generator_args|
  When %{I run "script/generate mongoid_migration #{generator_args}"}
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
