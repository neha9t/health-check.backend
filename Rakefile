#task :default => :test

desc "Run all tests"
task(:test) do
  Dir['./tests/*_test.rb'].each { |f| load f }
end