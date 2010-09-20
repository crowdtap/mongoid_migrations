module RailsHelpers
  def rails_root_exists?
    File.exists?(environment_path)
  end

  def environment_path
    File.join(RAILS_ROOT, 'config', 'environment.rb')
  end

  def gemfile_path
    gemfile = File.join(RAILS_ROOT, 'Gemfile')
  end

  def bundle_gem(gem_name)
    File.open(gemfile_path, 'a') do |file|
      file.puts("gem '#{gem_name}'")
    end
  end
end

World(RailsHelpers)
