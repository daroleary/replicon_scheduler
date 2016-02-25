require 'rails_helper'

RSpec.describe Events, type: :model do

  let(:employee) {build(:employee) }
  let(:other_employee) {build(:other_employee) }
  let(:events) { Events.new('2015/06/01'.to_date) }

  context '#initialize' do
    before(:each) do
      @employee_events = Hash.new { |hash, key| hash[key] = [] }
    end

    it 'should instantiate the object based on given values' do

      expect(events).to be_a_kind_of(Events)
      expect(events.start_date).to eql('2015/06/01'.to_date)
      expect(events.employee_events).to eql(Hash.new)
    end

    it 'should add employee event' do
      @employee_events[employee.id] << employee_event(1)

      expect(events.employee_events).to eql(Hash.new)

      events.add_employee_event(employee, 1)

      expect(events.employee_events).to eq(@employee_events)
    end

    it 'should fetch all events without keys' do
      @employee_events[employee.id] << employee_event(1)
      @employee_events[employee.id] << employee_event(2)
      @employee_events[other_employee.id] << employee_event_from(other_employee,1)

      events.add_employee_event(employee, 1)
      events.add_employee_event(employee, 2)
      events.add_employee_event(other_employee, 1)

      expect(events.employee_events).to eq(@employee_events)

      all_events = events.all_events

      expect(all_events).to be_a_kind_of(Array)
      expect(all_events.size).to eq(3)
    end

    it 'should fetch specific employee information' do
      events.add_employee_event(employee, 1)
      events.add_employee_event(employee, 2)
      events.add_employee_event(other_employee, 1)

      expect(events.fetch_employee_events(other_employee.id)).to eq([employee_event_from(other_employee,1)])
    end

  end

  def employee_event(day)
    employee_event_from(employee,day)
  end

  def employee_event_from(employee,day)
    {title: employee.name,
     id: employee.name.gsub(/[^0-9A-Za-z]/, ''),
     start: day}
  end
end