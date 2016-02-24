require 'rails_helper'
require 'replicon_scheduler_client/client'

RSpec.describe Scheduler, type: :class do

  let(:subject) { Scheduler.new([2]) }

  describe '#process_schedule' do

    before(:each) do
      allow(subject).to receive(:fetch_week).with(week.id) { week }
    end

    it 'should get schedule' do

      allow(subject).to receive(:fetch_employees) { get_employees }
      allow(subject).to receive(:fetch_employees_per_shift) { 1 }

      subject.schedule_employees

      expect(subject.events).to be_nil
      expect(subject.weeks).to eq([2])
      expect(subject.schedules.count).to eq(1)
      schedule = subject.schedules.first
      expect(schedule.week).to eq(2)
      expect(schedule.employees_per_shift).to eq(1)
      expect(schedule.week).to eq(2)
      expect(schedule.employee_shifts.count).to eq(7)
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
    employee_shifts = Hash.new { |hash, key| hash[key] = [] }
    (1..7).each do |day|
      employee_shifts[day] << get_employees.first
    end
    employee_shifts
  end
end