require 'rails_helper'
require 'replicon_scheduler_client/client'

RSpec.describe Scheduler, type: :class do

  let(:subject) { Scheduler.new([23]) }

  describe '#schedule_employees' do

    it 'should get schedule' do

      allow_any_instance_of(Schedule).to receive(:fetch_employees) { get_employees }
      allow_any_instance_of(Schedule).to receive(:fetch_employees_per_shift) { 2 }
      allow_any_instance_of(Schedule).to receive(:days_in_week) { 1..2 }

      schedules = subject.schedule_employees

      expect(schedules.count).to eq(1)
      weekly_schedule = schedules.first
      expect(weekly_schedule.week).to eq(23)

      actual_schedules = weekly_schedule.employee_schedules.employee_schedules
      expect(actual_schedules.count).to eq(2)
      expect(actual_schedules.values).to eq(get_employee_schedules)
    end
  end

  def employee_schedule(employee_id, day)
    {employee_id: employee_id, day: day}
  end

  def get_employees
    [employee(1, 'some.one.name'),
     employee(2, 'some.two.name')]
  end

  def employee(id, name)
    Employee.new(id: id, name: name)
  end

  def week
    Week.new(id: 23, start_date: '2015/06/01'.to_date)
  end

  def get_employee_schedules
    employee_schedules = []
    employee_schedules << fetch_employee_schedule(get_employees[0])
    employee_schedules << fetch_employee_schedule(get_employees[1])
  end

  def fetch_employee_schedule(employee)
    employee_schedule = EmployeeSchedule.new(employee)
    employee_schedule.add_day(1)
    employee_schedule.add_day(2)
    employee_schedule
  end
end