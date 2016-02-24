class Scheduler

  attr_reader :events, :schedules, :weeks

  def initialize(weeks)
    @weeks = weeks
    @schedules          = []
  end

  #TODO: break into smaller pieces
  def schedule_employees
    employees_per_shift = fetch_employees_per_shift
    employees           = fetch_employees

    @weeks.each do |week|
      schedule = Schedule.new(week, employees_per_shift)
      (1..7).each do |day|
        employees.each do |employee|
          break unless schedule.add_employee_to_schedule(employee, day)
        end
      end
      @schedules << schedule
    end
    @schedules
  end

  #TODO: break into smaller pieces & test each separately
  def fetch_events
    @events = Events.new(fetch_week(@weeks.first).start_date)
    schedule_employees.each do |schedule|
      start_date = fetch_week(schedule.week).start_date
      schedule.employee_shifts.map do |day,employee_shift|
        employee_shift.each do |employee|
          events.add_employee_event(employee, start_date+(day-1))
        end
      end
    end
    events
  end

  def client
    @client ||= RepliconSchedulerClient.create
  end

  def fetch_employees
    client.employees.uniq
  end

  def fetch_employees_per_shift
    client.employees_per_shift
  end

  def fetch_week(week_number)
    client.week(week_number)
  end
end