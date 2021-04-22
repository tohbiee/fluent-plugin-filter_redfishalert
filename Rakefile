require "bundler/gem_tasks"
require 'bundler'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.warning = true
end

task :default => :test

desc 'Open an irb session preloaded with the gem library'
task :console do
    sh 'irb -rubygems -I lib'
end
task :c => :console


