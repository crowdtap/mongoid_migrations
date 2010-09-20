Gem::Specification.new do |s|
  s.name          = "mongo_migration"
  s.version       = "0.1"
  s.date          = "2009-03-07"
  s.summary       = "Mongo Migrations in Rails"
  s.email         = "gyordanov@gmail.com"
  s.homepage      = "http://github.com/crowdtap"
  s.description   = "Mongo Migrations in Rails"
  s.has_rdoc      = false
  s.authors       = ["Galin Yordanov"]
  s.files         = Dir.glob("{generators,lib,tasks}/**/*") + %w(init.rb README.txt)
  s.require_paths = ["lib"]
end
