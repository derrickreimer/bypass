# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'detour/version'

Gem::Specification.new do |gem|
  gem.name          = "detour"
  gem.version       = Detour::VERSION
  gem.authors       = ["Derrick Reimer"]
  gem.email         = ["derrickreimer@gmail.com"]
  gem.description   = %q{Find and filter link URLs in any Ruby string}
  gem.summary       = %q{Find and filter link URLs in any Ruby string}
  gem.homepage      = "https://github.com/djreimer/detour"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency "nokogiri", "~> 1.5"
  gem.add_dependency "addressable", "~> 2.0"
  gem.add_development_dependency "shoulda-context", "~> 1.0"
  gem.add_development_dependency "mocha"
end
