
require 'rubygems'
require 'bundler'
require 'resque/server'


Bundler.require

require './app'

use Rack::MethodOverride
run Rack::URLMap.new \
  "/resque" => Resque::Server.new


run ApplicationController