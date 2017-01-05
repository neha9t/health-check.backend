
require 'rubygems'
require 'bundler'
require 'resque/server'


Bundler.require

require './app'

use Rack::MethodOverride

Resque.logger.formatter = Resque::VeryVerboseFormatter.new


run ApplicationController