$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mayak_generator/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mayak_generator"
  s.version     = MayakGenerator::VERSION
  s.authors     = ["dissident"]
  s.email       = ["chereshkevichsv@gmail.com"]
  s.homepage    = "http://google.com"
  s.summary     = "Geneartor for Mayak"
  s.description = "Generator for Mayak"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

end
