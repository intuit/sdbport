# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sdbport/version'

Gem::Specification.new do |gem|
  gem.name          = "sdbport"
  gem.version       = Sdbport::VERSION
  gem.authors       = ["Brett Weaver"]
  gem.email         = ["brett@weav.net"]
  gem.description   = %q{Import and export AWS SimpleDB domains.}
  gem.summary       = %q{Import and export AWS SimpleDB domains.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "rake"

  gem.add_runtime_dependency "fog", "= 1.6.0"
  gem.add_runtime_dependency "trollop", "= 2.0"
end
