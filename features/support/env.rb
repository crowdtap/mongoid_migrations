$:.unshift(File.dirname(__FILE__) + "/../../generators")
require "rubygems"
require 'active_support'
require 'rails_generator'
require 'rails_generator/scripts/generate'

require "rails_generator"
require 'rails_generator/scripts/generate'
require "fileutils"
require "mongoid_migration/mongoid_migration_generator"
 
app_root  = File.join(File.dirname(__FILE__), "/../../")
tmp_rails_app_name  = "tmp_rails_app"
tmp_rails_app_root  = File.join(app_root, tmp_rails_app_name)
 
Rails::Generator::Base.append_sources(Rails::Generator::PathSource.new(:plugin, "#{app_root}/rails_generators/"))

module GeneratorHelpers
  def generate_rails_app
    FileUtils.mkdir(File.join(@app_root))
  end    
 
  def generate_migration()
    Rails::Generator::Scripts::Generate.new.run(['mongoid_migration','test_migration'], :destination => @app_root, :backtrace => true)
  end
 
end
 
Before do
  @app_root = tmp_rails_app_root
end
 
After do
  FileUtils.rm_rf(tmp_rails_app_root)
end
 
World(GeneratorHelpers)