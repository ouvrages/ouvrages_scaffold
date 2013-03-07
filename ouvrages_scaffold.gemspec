# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ouvrages_scaffold/version'

Gem::Specification.new do |gem|
  gem.name          = "ouvrages_scaffold"
  gem.version       = OuvragesScaffold::VERSION
  gem.authors       = ["Ouvrages"]
  gem.email         = ["contact@ouvrages-web.fr"]
  gem.description   = %q{Rails scaffold in HAML, using cancan and bootstrap}
  gem.summary       = %q{Rails generators that produce HAML views to be used with Bootstrap and Cancan.}
  gem.homepage      = "https://github.com/ouvrages/rails-cancan-bootstrap-scaffold"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'bootstrap_forms'
  gem.add_dependency 'httparty'
end


