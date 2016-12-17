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
  FormDetails.auto_upgrade!
end

class ApplicationControllerTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods



  def app
    @app ||= ApplicationController.new
  end

  # def test_1_home_page
  #   get '/'
  #   assert last_response.status, '200'
  # end

  # def test_2_show_form
  #   get '/show'
  #   assert last_response.status, '200' 
  # end

  # def test_3_submit_form_new
  #   @details = FactoryGirl.create(:details)
  #   post '/details/new', params={:url => @details.url , :method_name => "GET", :interval => @details.interval.to_s}
  #   puts last_response.body
  #   assert_equal last_response.status, 302
  # end

  # def test_4_view_details
  #   get '/details'
  #   assert_equal last_response.status, 200
  # end

  # def test_5_view_single_detail
  #   @details = create(:details)
  #   binding.pry
  #   post '/details/new', params={:url => @details.url, :method_name => "GET", :interval => @details.interval.to_s}
  #   @details.save
  #   get '/details/:id', params={:id => @details.id.to_s}
  #   assert_equal last_response.status, 200
  # end

  # def test_6_updated_details
  #   @details = create(:details)
  #   binding.pry
  #   put '/details/:id', params={:id => @details.id, :url => 'http://neha.com', :method_name => "GET", :interval => '6'}
  #   assert_equal last_response.status, 302
  # end

  def test_7_view_single_detail
    @details = create(:details)
    get '/:id/delete' ,:id => 1
    binding.pry
    assert last_response.ok?
  end

  # def test_8_delete_single_detail
  #   delete '/:id' , :id => 1
  #   puts "delete single details : " + last_response.to_s
  #   assert last_response.ok?
  # end

end