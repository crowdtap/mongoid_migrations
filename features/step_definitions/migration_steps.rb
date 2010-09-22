Then /^the generated migration should contain "([^\"]*)"$/ do |text|
  File.read(last_migration_filename).should include(text)
end

Then /^I should have a new migration file$/ do
  File.basename(last_migration_filename).should match /[0-9]*_test_migration.rb/
end

When /^I edit the last migration's up method to be:$/ do |up_method|
  content = File.read(last_migration_filename)
  content.gsub! 'def self.up', %{
    def self.up
      #{up_method}
  }
  File.open(last_migration_filename, 'w') {|f| f.write(content) }
end
