When /^I setup my Rails 2.3 app with Bundler$/ do
  @terminal.cd RAILS_ROOT
  FileUtils.cp File.join(PROJECT_ROOT, 'features', 'support', 'fixtures', 'Gemfile'), RAILS_ROOT
  require_bundler_in_boot_rb
  create_preinitializer
end
