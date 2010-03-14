$:.unshift(File.dirname(__FILE__) + "/../../generators")
require "rubygems"
require 'spec/expectations'
require 'spec/mocks'
require 'active_support'
require 'rails_generator'
require 'rails_generator/scripts/generate'
require "fileutils"
require 'mongoid'
require "mongoid_migration/mongoid_migration_generator"
require "init"

app_root  = File.join(File.dirname(__FILE__), "/../../")
tmp_rails_app_name  = "tmp_rails_app"
tmp_rails_app_root  = File.join(app_root, tmp_rails_app_name)
 
Rails::Generator::Base.append_sources(Rails::Generator::PathSource.new(:plugin, "#{app_root}/rails_generators/"))

module GeneratorHelpers
  def generate_rails_app
    FileUtils.mkdir(File.join(@app_root))
  end    

  def capture_output(&block)
    orig_std_out = STDOUT.clone
    STDOUT.reopen(File.open('OUTPUT', 'w+'))
    yield
  ensure
    STDOUT.reopen(orig_std_out)
    @std_output = File.read('OUTPUT')
  end

  def generate_migration(name)
    capture_output{
      Rails::Generator::Scripts::Generate.new.run(
            ['mongoid_migration',name],
            :destination => @app_root, :quiet => true
      )
    }
  end
 
end
 
Before do
  @app_root = tmp_rails_app_root
  Mongoid.configure do |config|
    name = 'mongoid_migrations_test_database'
    host = 'localhost'
    config.master = Mongo::Connection.new.db(name)
  end
  Mongoid.database.collections.each {|c| c.drop}
end
 
After do
  FileUtils.rm_rf(tmp_rails_app_root)
  Mongoid.database.collections.each {|c| c.drop}
end
 
World(GeneratorHelpers)
