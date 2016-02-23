class Events
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :start_date, :employee_events

  def initialize(start_date)
    @start_date = start_date
    @employee_events = Hash.new { |hash, key| hash[key] = [] }
  end

  def add_employee_event(employee, day)
    @employee_events[employee.id] << {title: employee.name,
                                      id: employee.name.gsub(/[^0-9A-Za-z]/, ''),
                                      start: day}
  end

  def all_events
    @employee_events.values.flatten
  end

  def employee_events(employee_id)
    @employee_events[employee_id]
  end
end