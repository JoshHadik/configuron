$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "configuron/version"

Gem::Specification.new do |s|
  s.name        = 'configuron'
  s.version     = Configuron::VERSION
  s.date        = '2018-04-21'
  s.summary     = "Lightweight library to make your module configurable!"
  s.description = "A simple gem for configuration"
  s.homepage    = "https://github.com/JoshHadik/Configuron"
  s.authors     = ["Josh Hadik"]
  s.email       = 'josh.hadik@gmail.com'
  s.files       = Dir.glob("{lib}/**/*")
  s.homepage    =
    'https://github.com/JoshHadik/Configuron'
  s.license       = 'MIT'

  s.add_development_dependency "bundler", "~> 1.16"
  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "rspec", "~> 3.0"
end
