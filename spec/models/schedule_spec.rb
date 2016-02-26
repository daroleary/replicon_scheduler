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

      expect(actual.shifts.count).to eq(1)

      employees = actual.shifts[1]
      expect(employees.count).to eq(2)
      expect(employees[0]).to eq(employee)
      expect(employees[1]).to eq(other_employee)
    end

    it 'should not assign more shifts allowed' do
      another_employee = Employee.new(id: 3, name: 'other.other.employee')
      allow(subject).to receive(:fetch_employees) { [employee, another_employee, other_employee] }

      actual = subject.fetch_schedule

      employees = actual.shifts[1]
      expect(employees.count).to eq(2)
      expect(employees[0]).to eq(employee)
      expect(employees[1]).to eq(another_employee)
    end
  end
end