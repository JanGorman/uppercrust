# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crust/version'

Gem::Specification.new do |spec|
  spec.name = 'crust'
  spec.version = Crust::VERSION
  spec.authors = ['Jan Gorman']
  spec.email = %w(gorman.jan@gmail.com)
  spec.description = %q{Convert your JSON schema files to Mantle compatible Objective-C models}
  spec.summary = %q{Convert your JSON schema files to Mantle compatible Objective-C models}
  spec.homepage = 'https://github.com/JanGorman/crust/'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'aruba'

  spec.add_dependency 'thor'
  spec.add_dependency 'json'
  spec.add_dependency 'mustache'
end
