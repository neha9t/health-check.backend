require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'data_mapper' # metagem, requires common plugins too.

class ApplicationController < Sinatra::Base

  not_found do
    "Whoops! You requested a route which is not available"
  end

  configure do
    set :show_exceptions, :after_handler
    set :views, File.expand_path('../../views', __FILE__)
  end

  error do
  'Sorry there was a nasty error - ' + env['sinatra.error'].message
  end
end


# If you want the logs displayed you have to do this before the call to setup
#DataMapper::Logger.new($stdout, :debug)
#binding.pry

# A Sqlite3 connection to a persistent database
DataMapper.setup(:default, 'sqlite:development.db')

class FormDetails
  include DataMapper::Resource
  property :id,           Serial
  property :url,          String, :required => true
  property :method,       String, :required => true
  property :interval,     String, :required => true
  property :created_at,   DateTime
end
# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
#  The `DataMapper.finalize` method is used to check the integrity of your models.
# It should be called after ALL your models have been created and before your app starts interacting with them.
DataMapper.finalize

DataMapper.auto_migrate!


class FormdetailsController < ApplicationController

  get '/' do
    erb :index
  end

  post '/api/details' do
    params.to_s
    "Hello, world, I am the new change!"
    @formdetails = FormDetails.new(params)
    @formdetails.save
    @formdetails.to_json
    # else
    # halt 500
    # end
  end

  get '/details' do
    erb :all
    #@formdetails = FormDetails.all(:order => :created_at.desc)
    #@formdetails.to_json
  end
end




