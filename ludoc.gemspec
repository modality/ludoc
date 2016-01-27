# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ludoc/version'

Gem::Specification.new do |spec|
  spec.name = 'ludoc'
  spec.version = Ludoc::VERSION
  spec.author = 'Michael Hansen'
  spec.email = 'modality2@gmail.com'
  spec.summary = 'ludoc is a tool for game prototyping'
  spec.homepage = 'http://subtlefish.com'
  spec.license = 'MIT'
  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths << 'lib'
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "prawn"
end
