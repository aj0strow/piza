# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'piza/version'

Gem::Specification.new do |spec|
  spec.name          = 'piza'
  spec.version       = Piza::VERSION
  spec.authors       = %w(aj0strow)
  spec.email         = 'alexander.ostrow@gmail.com'
  spec.description   = 'Tower Of Piza'
  spec.summary       = 'Build up APIs with ease'
  spec.homepage      = 'http://github.com/aj0strow/piza'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(/spec/)
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sinatra'
  spec.add_development_dependency 'rack-test'
end
