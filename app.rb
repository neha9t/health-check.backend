require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'data_mapper' # metagem, requires common plugins too.

# If you want the logs displayed you have to do this before the call to setup
#DataMapper::Logger.new($stdout, :debug)
#binding.pry

# A Sqlite3 connection to a persistent database
DataMapper.setup(:default, 'sqlite:development.db')

class FormDetails
  include DataMapper::Resource
  property :id,           Serial
  property :url,          String, :required => true
  property :method,       String
  property :created_at,   DateTime
end
# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
#  The `DataMapper.finalize` method is used to check the integrity of your models.
# It should be called after ALL your models have been created and before your app starts interacting with them.
DataMapper.finalize

DataMapper.auto_migrate!


class HealthCheckApp < Sinatra::Base
  

  post '/submit' do
    params.to_s
    "Hello, world, I am the new change!"
  end
end
