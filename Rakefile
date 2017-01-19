#task :default => :test
require './app'
require 'resque/tasks'
require 'resque/scheduler/tasks'

desc "Run all tests"
task(:test) do
  Dir['./tests/*_test.rb'].each { |f| load f }
end

namespace :resque do
	desc 'Initialize Resque environment'
  task :setup do
    require 'resque'

    Resque.redis = 'localhost:6379'

  end

  task :setup_schedule => :setup do
    require 'resque-scheduler'
    Resque::Scheduler.dynamic = true
  end

  task :scheduler => :setup_schedule
end
