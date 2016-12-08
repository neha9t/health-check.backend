
require 'rubygems'
require 'bundler'


Bundler.require

require './app'

use Rack::MethodOverride
run ApplicationController