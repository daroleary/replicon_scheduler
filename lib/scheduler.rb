class Scheduler

  attr_reader :schedules

  def initialize(weeks)
    @weeks                 = weeks
    @schedules             = []
  end

  def schedule_employees
    (@weeks).each do |week|
      @schedules << Schedule.new(week).fetch_schedule
    end
    @schedules
  end

  #TODO: break into smaller pieces & test each separately
  def fetch_events
    events = Events.new(fetch_week(@weeks.first).start_date)
    schedule_employees.each do |schedule|
      start_date = fetch_week(schedule.week).start_date
      schedule.shifts.map do |day,employee_shift|
        employee_shift.each do |employee|
          events.add_employee_event(employee, start_date+(day-1))
        end
      end
    end
    events
  end

  private

  def client
    @client ||= RepliconSchedulerClient.create
  end

  def fetch_week(week_number)
    client.week(week_number)
  end
end