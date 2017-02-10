require 'sidekiq'
require 'pry'
require_relative '../app.rb'

#Sidekiq
Sidekiq.configure_client do |config|
  config.redis = { url: "redis://localhost:6379/1" }
end

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://localhost:6379/1"}
end

#Worker
class HealthCheck
  
  include Sidekiq::Worker
  sidekiq_options :queue => :check, :retry => true, :backtrace => true
  def perform(details_id)
    record = FormDetails.all(:id => details_id)
    record_url = record.first.url
    if record.first.enabled == true
      count = 0
      session_response = RestClient.get(record_url, headers={})
      session_code = session_response.code

      if session_code != 200
          # Send mail
      else
          mail_health_check("hunny.iib@gmail.com")
          count = count + 1
          count.to_s
          puts "I am inside ELSE before recurring for #{count} times"
          #Resque.enqueue_in(record.first.interval.second.from_now, Check, details_id)
          HealthCheck.perform_in(record.first.interval.second.from_now,details_id)

          record.first.status = "Last Run: #{Time.now}"
          record.save
          puts "I am inside ELSE after recurring for #{count} times"
      end
    end
  end
end