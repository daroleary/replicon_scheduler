class Schedule
  attr_reader :week, :schedules

  def initialize(week)
    @week = week
    @schedules = []
    @employees_per_shift = fetch_employees_per_shift
  end

  def fetch_schedule
    employee_schedules = Hash.new { |hash, key| hash[key] = [] }
    (days_in_week).each do |day|
      add_employees_to_schedule(employee_schedules, day)
    end
    generate_schedules_from(employee_schedules)
    self
  end

  def to_json
    {week: @week, schedules: @schedules}
  end

  private

  # Add employee shift to schedule
  # returns false if limit has already reached
  def add_employees_to_schedule(employee_schedules, day)
    num_of_shifts_assigned = 0
    fetch_employees.each do |employee|
      unless @employees_per_shift == num_of_shifts_assigned
        num_of_shifts_assigned += 1
        employee_schedules[employee.id] << day
      end
    end
  end

  def generate_schedules_from(employee_schedules)
    employee_schedules.each do |employee_id, employee_schedule|
      @schedules << {employee_id: employee_id, schedule: employee_schedule}
    end
  end

  def days_in_week
    1..7
  end

  def fetch_employees
    client.employees.uniq
  end

  def fetch_employees_per_shift
    client.employees_per_shift
  end

  def client
    @client ||= RepliconSchedulerClient.create
  end
end