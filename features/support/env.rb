require 'active_support'
require 'spec'
require 'fileutils'
require 'mongo'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..')).freeze
TEMP_DIR     = File.join(PROJECT_ROOT, 'tmp').freeze
RAILS_ROOT   = File.join(TEMP_DIR, 'rails_root').freeze

Before do
  FileUtils.rm_rf(TEMP_DIR)
  FileUtils.mkdir_p(TEMP_DIR)
end

After do
  FileUtils.rm_rf(TEMP_DIR)
end
