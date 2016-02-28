require 'rails_helper'

RSpec.describe EmployeeSchedules, type: :model do

  let(:employee) { build(:employee) }
  let(:other_employee) { build(:other_employee) }
  let(:subject) { EmployeeSchedules.new }

  context '#initialize' do
    it 'employee schedules should be empty' do
      expect(subject.employee_schedules.empty?).to be_truthy
    end
  end

  context '#schedule_employee' do
    it 'should schedule employees' do
      day = 1
      subject.schedule_employee(employee, day)

      employee_schedules = subject.employee_schedules
      expect(employee_schedules.empty?).to be_falsey
      expect(employee_schedules.count).to eq(1)

      expect(employee_schedules.include?(employee.id)).to be_truthy
      employee_schedule = employee_schedules[employee.id]
      expect(employee_schedule.employee).to eq(employee)
      expect(employee_schedule.days_scheduled).to eq([day])
    end
  end

  context '#assigned_shifts' do
    it 'should return the number of shifts assigned for a given day' do
      subject.schedule_employee(employee, 2)
      subject.schedule_employee(employee, 3)
      subject.schedule_employee(employee, 4)
      subject.schedule_employee(other_employee, 1)
      subject.schedule_employee(other_employee, 2)

      expect(subject.assigned_shifts(1)).to eq(1)
      expect(subject.assigned_shifts(2)).to eq(2)
      expect(subject.assigned_shifts(3)).to eq(1)
      expect(subject.assigned_shifts(4)).to eq(1)
      expect(subject.assigned_shifts(5)).to eq(0)
    end
  end
end