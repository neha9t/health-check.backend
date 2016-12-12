
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
    set :views, File.expand_path('../views', __FILE__)
  end

  error do
  'Sorry there was a nasty error - ' + env['sinatra.error'].message
  end

  get '/' do
    erb :index
  end

   get '/show' do
    erb :api_form
  end

  post '/details/new' do
    params.to_s
    "Hello, world, I am the new change!"
    @details = FormDetails.new(params)
    @details.save
    redirect to("/details")
  end

  get '/details' do
    @details = FormDetails.all(:order => :created_at.desc)
    redirect '/details/new' if @details.empty?
    erb :view_all
  end

  get '/details/:id' do
    @details = FormDetails.get(params[:id])
    @title = "Edit note ##{params[:id]}"
    erb :edit
  end

  put '/details/:id' do
    @details = FormDetails.get(params[:id])
    @details.method = params[:method]
    @details.interval = params[:interval]
    @details.url = params[:url]
    @details.save
    redirect to("/details")
  end

  get '/:id/delete' do
    @details = FormDetails.get(params[:id])
    @title = "Edit note ##{params[:id]}"
    erb :delete
  end

  delete '/:id' do
    @details = FormDetails.get(params[:id])
    @details.destroy
    redirect to("/details") 
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
