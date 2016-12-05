
require 'rubygems'
require 'bundler'
Dir.glob('./app/{models,controllers}/*.rb').each { |file| require file }

Bundler.require

run ApplicationController