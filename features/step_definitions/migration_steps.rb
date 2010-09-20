Then /^the generated migration should contain "([^\"]*)"$/ do |text|
  File.read(first_migration).should include(text)
end

Then /^I should have a new migration file$/ do
  File.basename(first_migration).should match /[0-9]*_test_migration.rb/
end
