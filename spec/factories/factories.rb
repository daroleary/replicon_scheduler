require 'faker'

FactoryGirl.define do
  @@sequential_employee_id = 0

  factory :employee do |em|
    em.sequence(:id) {|n| n}
    em.name { Faker::Name.name }
  end

  factory :employee_schedule do
    initialize_with { new(get_employee) }

    after(:build) {|employee_schedule| (1..5).select{ [true, false].sample }.each{|day|employee_schedule.add_day day}}
  end
end

def get_employee
  Employee.new({id: @@sequential_employee_id +=1, name: Faker::Name.name})
end