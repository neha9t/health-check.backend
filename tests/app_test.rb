ENV['RACK_ENV'] = 'test'

require_relative '../app'
require File.dirname(__FILE__) + '/test_helper'
require 'test/unit'
require 'rack/test'
require 'pry'


configure do
  DataMapper::setup(:default, "sqlite3:test.db")
  DataMapper.finalize
  DataMapper.auto_migrate!
  binding.pry
  FormDetails.auto_upgrade!
end

class ApplicationControllerTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  def app
    @app ||= ApplicationController.new
  end

  def test_1_home_page
    get '/'
    assert last_response.status, '200'
  end

  def test_2_show_form
    get '/show'
    assert last_response.status, '200' 
  end

  def test_3_submit_form_new
    @details = FactoryGirl.create(:details)
    post '/details/new', params={:url => @details.url , :method_name => "GET", :interval => @details.interval.to_s}
    puts last_response.body
    assert_equal last_response.status, 302
  end

  def test_4_view_details
    get '/details'
    assert_equal last_response.status, 200
  end

  def test_5_view_single_detail
    @details = FactoryGirl.create(:details)
    get '/details/1'
    assert_equal last_response.status, 200
  end

  def test_6_updated_details
    @details = FactoryGirl.create(:details)
    put '/details/1', params={:url => 'http://neha.com', :method_name => "GET", :interval => '6'}
    assert_equal last_response.status, 302
  end

  def test_7_view_single_detail
    @details = FactoryGirl.create(:details)
    get '/1/delete'
    assert last_response.ok?
  end

  def test_8_delete_single_detail
    @details = FactoryGirl.create(:details)
    delete '/1'
    assert_equal last_response.status, 302
  end

end