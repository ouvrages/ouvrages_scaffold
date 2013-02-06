# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-cancan-bootstrap-scaffold/version'

Gem::Specification.new do |gem|
  gem.name          = "rails-cancan-bootstrap-scaffold"
  gem.version       = Rails::Cancan::Bootstrap::Scaffold::VERSION
  gem.authors       = ["Ouvrages"]
  gem.email         = ["contact@ouvrages-web.fr"]
  gem.description   = %q{Bootstrap & cancan generators for Rails}
  gem.summary       = %q{Rails generators that produce standard code for Bootstrap and Cancan.}
  gem.homepage      = "https://github.com/ouvrages/rails-cancan-bootstrap-scaffold"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'bootstrap_forms'  
end


