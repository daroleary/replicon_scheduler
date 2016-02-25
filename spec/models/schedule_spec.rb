require 'rails_helper'

RSpec.describe Schedule, type: :model do

  let(:employee) { build(:employee) }
  let(:schedule) { Schedule.new(23, 1) }

  context '#initialize' do
    it 'should instantiate employee_schedule based on given values' do

      expect(schedule).to be_a_kind_of(Schedule)
      expect(schedule.employees_per_shift).to eql(1)
      expect(schedule.week).to eql(23)
    end

    it 'should add employee to schedule' do
      actual = schedule.add_employee_to_schedule(employee, 1)

      expect(actual).to be_truthy
      expect(schedule.number_of_shifts_assigned_for(1)).to eq(1)
      expect(schedule.employee_shifts.count).to eq(1)
      expect(schedule.employee_shifts[1].count).to eq(1)
      expect(schedule.employee_shifts[1].first).to eq(employee)
    end

    it 'should not exceed employees per shift' do

      schedule.add_employee_to_schedule(employee, 1)
      actual = schedule.add_employee_to_schedule(employee, 1)

      expect(actual).to be_falsey
    end
  end
end