# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'milan/version'

Gem::Specification.new do |spec|
  spec.name          = "milan"
  spec.version       = Milan::VERSION
  spec.authors       = ["Jeremy Friesen"]
  spec.email         = ["jeremy.n.friesen@gmail.com"]

  spec.summary       = %q{A library for building models via a configuration.}
  spec.description   = %q{A library for building models via a configuration.}
  spec.homepage      = "https://github.com/jeremyf/milan"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "hanami-utils", "~> 0.6"
  spec.add_dependency "dry-equalizer", "~> 0.2"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "reek"
  spec.add_development_dependency "flay"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "shoulda-matchers"
  spec.add_development_dependency "codeclimate-test-reporter"
end
