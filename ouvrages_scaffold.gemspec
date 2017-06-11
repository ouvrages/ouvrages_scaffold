$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ouvrages_scaffold/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ouvrages_scaffold"
  s.version     = OuvragesScaffold::VERSION
  s.authors     = ["Ouvrages"]
  s.email       = ["contact@ouvrages-web.fr"]
  s.homepage    = "https://github.com/ouvrages/ouvrages_scaffold"
  s.summary     = "Ouvrages scaffold with HAML and CanCanCan using bootstrap"
  s.description = "Ouvrages generators that produce HAML views to be used with Bootstrap and CanCanCan."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.1"
  s.add_development_dependency "sqlite3"
end
