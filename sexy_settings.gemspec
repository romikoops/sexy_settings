# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sexy_settings/version"

Gem::Specification.new do |s|
  s.name        = "sexy_settings"
  s.version     = SexySettings::VERSION
  s.authors     = ["Roman Parashchenko"]
  s.email       = ["romikoops1@gmail.com"]
  s.homepage    = "https://github.com/romikoops/sexy_settings"
  s.summary     = %q{Flexible specifying of application settings}
  s.description = %q{Library for flexible specifying of application settings different ways}
  s.rubyforge_project = "sexy_settings"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_development_dependency 'rspec'
  s.add_development_dependency('rake')
end
