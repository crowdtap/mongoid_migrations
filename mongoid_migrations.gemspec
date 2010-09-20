Gem::Specification.new do |s|
  s.name     = "mongoid_migration"
  s.version  = "0.1"
  s.date     = "2009-03-07"
  s.summary  = "Mongoid Migrations in Rails"
  s.email    = "gyordanov@gmail.com"
  s.homepage = "http://github.com/crowdtap"
  s.description = "Mongoid Migrations in Rails"
  s.has_rdoc = false
  s.authors  = ["Galin Yordanov"]
  s.files    = Dir.glob("{generators,lib,tasks}/**/*") + %w(init.rb README.txt)
  s.require_paths = ["lib"]
end
