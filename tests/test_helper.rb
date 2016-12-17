require 'faker'
require 'factory_girl'

FactoryGirl.define do
  factory :details, :class => FormDetails do
    sequence(:id) { |number| number } 
    url       {Faker::Internet.url}
    method_name    "GET"
    interval   {Faker::Number.between(1, 10)}
  end
end 