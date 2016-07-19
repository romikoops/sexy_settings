# -*- encoding: utf-8 -*-
# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'sexy_settings/version'

Gem::Specification.new do |s|
  s.name        = 'sexy_settings'
  s.version     = SexySettings::VERSION
  s.authors     = ['Roman Parashchenko']
  s.email       = ['romikoops1@gmail.com']
  s.homepage    = 'https://github.com/romikoops/sexy_settings'
  s.summary     = 'Flexible specifying of application settings'
  s.description = 'Library for flexible specifying of application settings different ways'
  s.rubyforge_project = 'sexy_settings'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 1.9.3'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.add_development_dependency 'rspec', '~>3.5'
  s.add_development_dependency('rake')
  s.add_development_dependency('yard')
end
