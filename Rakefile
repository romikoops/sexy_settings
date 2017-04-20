require 'rubygems'
require 'bundler'
Bundler.setup

require 'rake'
require 'yard'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec) { |_spec| }

YARD::Rake::YardocTask.new { |_t| }

RuboCop::RakeTask.new

task default: %i[rubocop spec]
