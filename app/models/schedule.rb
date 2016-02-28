class Schedule
  attr_reader :week, :employee_schedules

  def initialize(week)
    @week = week
    @employees_per_shift = fetch_employees_per_shift
    @employee_schedules   = EmployeeSchedules.new
  end

  def process_schedule
    (days_in_week).each do |day|
      fetch_employees.each do |employee|
        break if employee_schedules.assigned_shifts(day) == @employees_per_shift
        employee_schedules.schedule_employee(employee, day)
      end
    end
    self
  end

  def to_json
    {week: @week, schedules: @employee_schedules}
  end

  private

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