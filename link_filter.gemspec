# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'link_filter/version'

Gem::Specification.new do |gem|
  gem.name          = "link_filter"
  gem.version       = LinkFilter::VERSION
  gem.authors       = ["Derrick Reimer"]
  gem.email         = ["derrickreimer@gmail.com"]
  gem.description   = %q{Find and filter link URLs in any Ruby string}
  gem.summary       = %q{Find and filter link URLs in any Ruby string}
  gem.homepage      = "https://github.com/djreimer/link_filter"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency "shoulda-context", "~> 1.0"
end
