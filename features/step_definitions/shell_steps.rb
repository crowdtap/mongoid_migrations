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

Then /^I should see mongo_migration's USAGE$/ do
  steps %{
    Then I should see "Usage: ./script/generate mongo_migration MigrationName [options]"
  }
end
