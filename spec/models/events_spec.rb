require 'rails_helper'

RSpec.describe Events, type: :model do

  let(:employee) { build(:employee) }
  let(:other_employee) { build(:other_employee) }
  let(:another_employee) { Employee.new(id: 3, name: Faker::Name.name) }
  let(:subject) { Events.new(fetch_schedules) }
  let(:empty_subject) { Events.new([]) }

  before(:each) do
    @employee_events = Hash.new { |hash, key| hash[key] = [] }
    allow(subject).to receive(:fetch_schedule_start_date) { '2015/06/01'.to_date }
  end

  context '#fetch_events' do
    it 'should raise exception if no schedules are provide' do
      expect { empty_subject.fetch_events }.to raise_error ArgumentError, 'At least one schedule must be provided'
    end

    it 'should fetch all start date' do
      events = subject.fetch_events
      start_date = Date.new(2015, 6, 1)
      expect(events.schedule_start_date).to eql(start_date)
    end

    it 'should fetch all events with employee id keys' do
      events = subject.fetch_events
      start_date = events.schedule_start_date

      employee_events = events.employee_events
      expect(employee_events.count).to eq(2)
      employee_events = employee_events[employee.id]
      expect(employee_events.count).to eq(4) # 2 weeks x 2 days per week

      expect(employee_events[0]).to eq(employee_event_from(employee,start_date))
      expect(employee_events[1]).to eq(employee_event_from(employee,start_date+1))
      expect(employee_events[2]).to eq(employee_event_from(employee,start_date+7))
      expect(employee_events[3]).to eq(employee_event_from(employee,start_date+8))

      expect(employee_events[0]).to eq(employee_event_from(employee,start_date))
      expect(employee_events[1]).to eq(employee_event_from(employee,start_date+1))
      expect(employee_events[2]).to eq(employee_event_from(employee,start_date+7))
      expect(employee_events[3]).to eq(employee_event_from(employee,start_date+8))
    end

    it 'should fetch all events without keys' do
      events = subject.fetch_events

      employee_events = events.employee_events
      expect(employee_events).to be_a_kind_of(Hash)
      expect(employee_events.count).to eq(2)

      all_employee_events = events.all_events
      expect(all_employee_events).to be_a_kind_of(Array)
      expect(all_employee_events.size).to eq(8)
    end

    it 'should fetch specific employee information' do
      events = subject.fetch_events
      expect(events.fetch_employee_events(other_employee.id).count).to eq(4)
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
    [schedule(23), schedule(24)]
  end

  def schedule(week)
    schedule = Schedule.new(week)
    allow(schedule).to receive(:fetch_employees) { [employee, other_employee, another_employee] }
    allow(schedule).to receive(:fetch_employees_per_shift) { 2 }
    allow(schedule).to receive(:days_in_week) { 1..2 }
    schedule.process_schedule
  end

  def fetch_employee_event(start_date)
    {title: employee.name,
     id: employee.name.gsub(/[^0-9A-Za-z]/, ''),
     start: start_date}
  end
end