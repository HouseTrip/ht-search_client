# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ht/search_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'ht-search_client'
  spec.version       = Ht::SearchClient::VERSION
  spec.authors       = ['Matthew Hutchinson']
  spec.email         = ['mhutchinson@housetrip.com']
  spec.summary       = %q{A ruby client for the HouseTrip Property Search Service.}
  spec.description   = %q{A ruby client for the HouseTrip Property Search Service.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'json'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'safe_yaml', "~> 1.0.4"
end
