
require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper' # metagem, requires common plugins too.
#require 'resque'
require 'dm-migrations/migration_runner'
require 'rest-client'
require 'json'
require 'pry'
#require 'resque-scheduler'
#require 'resque/scheduler/server'
require 'active_support'
require 'active_support/core_ext'
#require 'resque/errors'
require_relative 'lib/sidekiq-worker'
require_relative 'lib/mailer.rb'

# app.rb
class ApplicationController < Sinatra::Base

  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
    end
  end

  not_found do
    "Whoops! You requested a route which is not available"
  end

  configure do
    set :show_exceptions, :after_handler
    set :views, File.expand_path('../views', __FILE__)
    DataMapper.auto_upgrade!
  end

  error do
  'Sorry there was a nasty error - ' + env['sinatra.error'].message
  end

  get '/' do
    erb :index
  end

  get '/login' do
    erb :login
  end

  get '/show' do
    erb :new
  end

  post '/login/' do
    protected!
    if authorized?
      redirect to '/details'
    end
  end

  post '/details/new' do
    params.to_s
    "Hello, world, I am the new change!"
    @details = FormDetails.new(params)
    @details.save
    binding.pry
    if params[:enabled] == "true"
      HealthCheck.perform_async(@details.id)
    end
    @details.to_json
    redirect to("/details")
  end

  get '/details' do
    protected!
    if authorized?
      @details = FormDetails.all(:order => :created_at.desc)
      redirect to('/show') if @details.empty?
      @details.to_json
      erb :view_all
    end
  end

  get '/details/:id' do
    @details = FormDetails.get(params[:id])
    @title = "Edit note ##{params[:id]}"
    @details.to_json
    erb :edit
  end

  put '/details/:id' do
    @details = FormDetails.get(params[:id])
    if params[:enabled] != @details.enabled
      if params[:enabled] == true
        HealthCheck.perform_async(@details.id)
      else
        
      end
    end
    @details.method_name = params[:method_name]
    @details.interval = params[:interval]
    @details.url = params[:url]
    @details.enabled = params[:enabled]
    @details.save
    @details.to_json
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

# A Sqlite3 connection to a persistent database
DataMapper.setup(:default, 'sqlite:development.db')

class FormDetails
  include DataMapper::Resource
  property :id,           Serial
  property :url,          String, :required => true
  property :method_name,  String, :required => true
  property :interval,     Integer, :required => true
  property :enabled,      Boolean, :required => true, :default => false
  property :status,       String, :required => true ,:default => "Not Running"
  property :created_at,   DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!
