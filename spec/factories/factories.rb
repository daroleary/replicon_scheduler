require 'faker'

FactoryGirl.define do
  factory :employee do
    name { Faker::Name.name }
  end

  # factory :dietary_restriction do
  #   sequence(:name) { |n| "dietary-restriction-#{n}" }
  # end
  #
  # factory :member do
  #   first_name { Faker::Name.first_name }
  #   last_name { Faker::Name.last_name }
  #   association :team
  #   association :dietary_restriction
  # end
  #
  # factory :stock do
  #   quantity 50
  #   association :dietary_restriction
  #   association :restaurant
  # end
  #
  # factory :restaurant do
  #   name { Faker::Name.name }
  #   rating 3
  # end
  #
  # factory :order do
  #   order_date Date.current
  #   association :team
  # end
  #
  # factory :meal do
  #   quantity 50
  #   association :dietary_restriction
  #   association :restaurant
  #   association :order
  # end
end