# -*- encoding: utf-8 -*-
require File.expand_path('../lib/neo/dci/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Peter Suschlik", "Jakob Holderbaum", "Jonas Thiel"]
  gem.email         = ["ps@neopoly.de", "jh@neopoly.de", "jt@neopoly.de"]
  gem.description   = %q{Simple DCI}
  gem.summary       = %q{Includes Data, Roles and Context.}
  gem.homepage      = "https://github.com/neopoly/neo-dci"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "neo-dci"
  gem.require_paths = ["lib"]
  gem.version       = Neo::DCI::VERSION

  gem.add_runtime_dependency 'on', '~> 1.0.0'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'testem'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.0'
end
