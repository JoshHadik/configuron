$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "configuron/version"

Gem::Specification.new do |s|
  s.name        = 'configuron'
  s.version     = Configuron::VERSION
  s.date        = '2018-04-21'
  s.summary     = "Super lightweight (like only three methods lightweight) library to add configuration options to a module."
  s.description = "A simple hello world gem"
  s.homepage    = "https://github.com/JoshHadik/Configuron"
  s.authors     = ["Josh Hadik"]
  s.email       = 'josh.hadik@gmail.com'
  s.files       = Dir.glob("{lib}/**/*")
  s.homepage    =
    'https://github.com/JoshHadik/Configuron'
  s.license       = 'MIT'

  s.add_development_dependency "bundler", "~> 1.16"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"
end
