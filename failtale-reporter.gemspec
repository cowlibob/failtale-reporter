# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler'
require 'failtale_reporter/version'

Gem::Specification.new do |s|
  s.name        = "failtale-reporter"
  s.version     = FailtaleReporter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Menke"]
  s.email       = ["simon.menke@gmail.com"]
  s.homepage    = "http://github.com/mrhenry"
  s.summary     = %q{A ruby reporter for Failtale}
  s.description = %q{A Ruby error reporter for the Failtale service}

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "failtale_reporter"

  s.require_path = 'lib'
  s.files        = Dir.glob("{lib,rails,spec}/**/*") +
                   %w(LICENSE README.md)

  # s.add_bundler_dependencies
  s.add_runtime_dependency 'httparty'
end