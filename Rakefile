require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'coveralls/rake/task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new
Coveralls::RakeTask.new

task test_with_coveralls: [:spec, :cucumber, 'coveralls:push']
task default: [:spec, :cucumber]
