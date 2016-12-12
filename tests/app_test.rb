ENV['RACK_ENV'] = 'test'

require_relative '../app'
require 'test/unit'
require 'rack/test'
require 'pry'


configure do
  DataMapper::setup(:default, "sqlite3:test.db")
  DataMapper.finalize
  DataMapper.auto_migrate!
end

class ApplicationControllerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    @app ||= ApplicationController.new
  end

  def test_home_page
    get '/'
    last_response.body
    assert last_response.ok?
  end

  def test_show_form
    get '/show'
    assert last_response.ok?
  end

  def test_view_details
    get '/details'
    assert last_response.ok?
  end

  def test_submit_form_new
    post '/details/new', params={:url => 'http://wikipedia.com', :method => 'GET', :interval => '3'}
    assert last_response.ok?
  end

  def test_view_single_detail
    get '/details/:id', :id => 1
    assert last_response.ok?
  end

   def test_view_single_detail
    get '/:id/delete' ,:id => 1
    assert last_response.ok?
  end

  def test_updated_details
    put '/details/:id', :id => 1
    assert last_response.ok?
  end

  def test_delete_single_detail
    delete '/:id' , :id => 1
    assert last_response.ok?
  end

end