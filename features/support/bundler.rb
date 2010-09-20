module BundlerHelpers
  def require_bundler_in_boot_rb
    bundler_config = %{
      class Rails::Boot
        def run
          load_initializer

          Rails::Initializer.class_eval do
            def load_gems
              @bundler_loaded ||= Bundler.require :default, Rails.env
            end
          end

          Rails::Initializer.run(:set_load_path)
        end
      end
    }

    path    = File.join(RAILS_ROOT, 'config', 'boot.rb')
    content = File.read(path).gsub(/Rails\.boot\!/) do |match|
      "#{bundler_config}\n #{match}"
    end
    File.open(path, 'wb') { |file| file.write(content) }
  end

  def create_preinitializer
    preinitializer = %{
      begin
        require "rubygems"
        require "bundler"
      rescue LoadError
        raise "Could not load the bundler gem. Install it with `gem install bundler`."
      end

      if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
        raise RuntimeError, "Your bundler version is too old for Rails 2.3." +
         "Run `gem install bundler` to upgrade."
      end

      begin
        # Set up load paths for all bundled gems
        ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
        Bundler.setup
      rescue Bundler::GemNotFound
        raise RuntimeError, "Bundler couldn't find some gems." +
          "Did you run `bundle install`?"
      end
    }

    path = File.join(RAILS_ROOT, 'config', 'preinitializer.rb')
    File.open(path, 'wb') { |file| file.write(preinitializer) }
  end
end

World(BundlerHelpers)
