Then /^the migrations collection should have documents for each migration$/ do
  migration_filenames.each do |filename|
    timestamp = filename.to_i
    document  = DB['migrations'].find('version' => timestamp).first
    document.should_not be_nil
  end
end

Then /^the "([^"]*)" collection should have a document with a "([^"]*)" of "([^"]*)"$/ do |collection_name, field, value|
  document  = DB[collection_name].find(field => value).first
  document.should_not be_nil
end

Then /^the migrations collection should be empty$/ do
  DB['migrations'].count.should == 0
end

And /^cleanup Mongo$/ do
  drop_collections
end
