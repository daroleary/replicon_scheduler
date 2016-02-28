class Events
  attr_reader :schedule_start_date, :employee_events

  def initialize(schedules)
    @schedules = schedules
    @employee_events = Hash.new { |hash, key| hash[key] = [] }
  end

  def fetch_events
    raise ArgumentError.new 'At least one schedule must be provided' if @schedules.nil? || @schedules.count < 1
    @schedule_start_date = fetch_schedule_start_date

    @schedules.each do |weekly_schedule|
      start_date = fetch_start_date(weekly_schedule.week)
      weekly_schedule.schedules.each do |employee_shifts|
        add_employee_events(employee_shifts, start_date)
      end
    end
    self
  end

  private

  def add_employee_events(employee_shifts, start_date)
    employee_id = employee_shifts[:employee_id]
    days = employee_shifts[:schedule]
    days.each do |day|
      add_employee_event(employee_id, start_date+(day-1))
    end
  end

  def add_employee_event(employee_id, day)
    employee = fetch_employee(employee_id)
    @employee_events[employee.id] << {title: employee.name,
                                      id: employee.name.gsub(/[^0-9A-Za-z]/, ''),
                                      start: day}
  end

  def fetch_start_date(week_number)
    fetch_week(week_number).start_date
  end

  def fetch_schedule_start_date
    first_schedule = @schedules.first
    raise ArgumentError.new 'First schedule week number must be provided' if first_schedule.week.nil?
    fetch_week(first_schedule.week).start_date
  end

  def fetch_employee_events(employee_id)
    @employee_events[employee_id]
  end

  def all_events
    @employee_events.values.flatten
  end

  def fetch_week(week_number)
    client.week(week_number)
  end

  def fetch_employee(employee_id)
    client.employee(employee_id)
  end

  def client
    @client ||= RepliconSchedulerClient.create
  end
end