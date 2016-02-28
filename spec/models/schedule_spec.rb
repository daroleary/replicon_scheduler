require 'rails_helper'

RSpec.describe Schedule, type: :model do

  let(:subject) { Schedule.new(23) }
  let(:employee) { build(:employee) }
  let(:other_employee) { build(:other_employee) }

  before(:each) do
    allow(subject).to receive(:days_in_week) { (1..1) }
    allow(subject).to receive(:fetch_employees_per_shift) { 2 }
    allow(subject).to receive(:fetch_employees) { [employee, other_employee] }
  end

  context '#initialize' do
    it 'should instantiate employee_schedule based on given values' do

      expect(subject).to be_a_kind_of(Schedule)
      expect(subject.week).to eql(23)
    end
  end

  context '#fetch_schedule' do
    it 'should fetch schedule' do

      actual = subject.fetch_schedule

      actual_schedules = actual.schedules
      expect(actual_schedules.count).to eq(2)

      employee_shift = actual_schedules[0]
      expect(employee_shift[:employee_id]).to eq(employee.id)
      expect(employee_shift[:schedule]).to eq([1])

      employee_shift = actual_schedules[1]
      expect(employee_shift[:employee_id]).to eq(other_employee.id)
      expect(employee_shift[:schedule]).to eq([1])
    end

    it 'should not assign more shifts allowed' do
      another_employee = Employee.new(id: 3, name: 'other.other.employee')
      allow(subject).to receive(:fetch_employees) { [employee, another_employee, other_employee] }

      actual_schedules = subject.fetch_schedule.schedules
      expect(actual_schedules.count).to eq(2)

      employee_shift = actual_schedules[0]
      expect(employee_shift[:employee_id]).to eq(employee.id)
      expect(employee_shift[:schedule]).to eq([1])

      employee_shift = actual_schedules[1]
      expect(employee_shift[:employee_id]).to eq(another_employee.id)
      expect(employee_shift[:schedule]).to eq([1])
    end

    it 'should fetch schedule over two days' do
      allow(subject).to receive(:days_in_week) { 1..2 }

      actual = subject.fetch_schedule

      actual_schedules = actual.schedules
      expect(actual_schedules.count).to eq(2)

      employee_shift = actual_schedules[0]
      expect(employee_shift[:employee_id]).to eq(employee.id)
      expect(employee_shift[:schedule]).to eq([1,2])

      employee_shift = actual_schedules[1]
      expect(employee_shift[:employee_id]).to eq(other_employee.id)
      expect(employee_shift[:schedule]).to eq([1,2])

      expect(actual.to_json).to eq(schedule_json)
    end
  end

  def schedule_json
    {week: 23,
     schedules: [{employee_id: 1, schedule: [1, 2]},
                 {employee_id: 2, schedule: [1, 2]}]
    }
  end
end