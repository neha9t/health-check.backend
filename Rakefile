#task :default => :test
require './app'
require 'resque/tasks'

desc "Run all tests"
task(:test) do
  Dir['./tests/*_test.rb'].each { |f| load f }
end