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