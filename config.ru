
require 'rubygems'
require 'bundler'
#require 'resque/server'
Bundler.require
require './app'

use Rack::MethodOverride

require 'sidekiq'

require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :db => 1 }
end

run Rack::URLMap.new('/' => ApplicationController, '/sidekiq' => Sidekiq::Web)