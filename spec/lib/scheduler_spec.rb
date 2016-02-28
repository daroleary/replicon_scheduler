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

      actual_schedules = weekly_schedule.schedules
      expect(actual_schedules.count).to eq(2)
      expect(actual_schedules).to eq(get_employee_shifts)
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

  def get_employee_shifts
    [{employee_id: get_employees[0].id, schedule: [1, 2]},
     {employee_id: get_employees[1].id, schedule: [1, 2]}]
  end
end