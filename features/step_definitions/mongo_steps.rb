Then /^the migrations collection should have a "([^"]*)" document$/ do |document_name|
  document = db['migrations'].find('name' => document_name).first
  document.should_not be_nil
end

Then /^the migrations collection should not have a "([^"]*)" document$/ do |document_name|
  document = db['migrations'].find('name' => document_name).first
  document.should be_nil
end

And /^cleanup Mongo$/ do
  drop_collections
end
