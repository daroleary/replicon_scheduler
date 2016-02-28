require 'rails_helper'

RSpec.describe Events, type: :model do

  let(:employee)       { build(:employee) }
  let(:other_employee) { build(:employee) }
  let(:subject)        { Events.new(fetch_schedules) }
  let(:empty_subject)  { Events.new([]) }

  before(:each) do
    @employee_events = Hash.new { |hash, key| hash[key] = [] }
    allow(subject).to receive(:fetch_schedule_start_date) { '2015/06/01'.to_date }
  end

  context '#fetch_events' do
    it 'should raise exception if no schedules are provide' do
      expect { empty_subject.fetch_events }.to raise_error ArgumentError, 'At least one schedule must be provided'
    end

    it 'should fetch all events without keys' do
      @employee_events[employee.id] << employee_event(1)
      @employee_events[employee.id] << employee_event(2)
      @employee_events[other_employee.id] << employee_event_from(other_employee, 1)

      expect(subject.fetch_events).to eq(@employee_events)

      all_events = subject.all_events

      expect(all_events).to be_a_kind_of(Array)
      expect(all_events.size).to eq(3)
    end
  end

  context '#fetch_events' do
    it 'should fetch all events without keys' do
      @employee_events[employee.id] << employee_event(1)
      @employee_events[employee.id] << employee_event(2)
      @employee_events[other_employee.id] << employee_event_from(other_employee, 1)

      events = subject.fetch_events

      expect(events.employee_events).to be_a_kind_of(Array)
      expect(all_events.size).to eq(3)
      expect(subject.employee_events).to eq(@employee_events)
    end

    it 'should fetch specific employee information' do
      subject.add_employee_event(employee, 1)
      subject.add_employee_event(employee, 2)
      subject.add_employee_event(other_employee, 1)

      expect(subject.fetch_employee_events(other_employee.id)).to eq([employee_event_from(other_employee, 1)])
    end

  end

  def employee_event(day)
    employee_event_from(employee, day)
  end

  def employee_event_from(employee, day)
    {title: employee.name,
     id: employee.name.gsub(/[^0-9A-Za-z]/, ''),
     start: day}
  end

  def fetch_schedules
    allow_any_instance_of(Schedule).to receive(:days_in_week) { 1..2 }

    schedules = []
    schedule = Schedule.new(23)
    schedules << schedule.process_schedule

    schedule = Schedule.new(24)
    schedules << schedule.process_schedule
    schedules
  end
end