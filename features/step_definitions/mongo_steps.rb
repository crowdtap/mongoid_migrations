Then /^the migrations collection should have a "([^"]*)" document$/ do |document_name|
  db['migrations'].find('name' => document_name).first
end

And /^cleanup Mongo$/ do
  drop_collections
end
