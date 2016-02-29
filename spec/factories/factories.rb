require 'faker'

FactoryGirl.define do
  factory :employee do |em|
    em.id 1
    em.name { Faker::Name.name }
  end

  factory :other_employee, class: Employee do |em|
    em.id 2
    em.name { Faker::Name.name }
  end
end