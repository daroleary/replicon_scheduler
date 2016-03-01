class Schedule
  attr_reader :week, :employee_schedules

  def initialize(week)
    @week = week
    @employees_per_shift = fetch_employees_per_shift
    @employee_schedules   = EmployeeSchedules.new
  end

  def process_schedule
    (days_in_week).each do |day|
      ordered_employees(@week, day).each do |employee|
        break if employee_schedules.assigned_shifts(day) == @employees_per_shift
        employee_schedules.schedule_employee(employee, day)
      end
    end
    self
  end

  def to_json
    {week: @week, schedules: @employee_schedules.to_json}
  end

  private

  def days_in_week
    1..7
  end

  # returns a list of employees ordered by time off and employee id
  def fetch_employees
    @fetch_employees ||= client.employees
  end

  # orders employee by time off asc and employee id
  def ordered_employees(week, day)
    fetch_employees.sort_by { |employee| [has_time_off?(employee.id, week, day) ? 1 : 0, employee.id] }
  end

  def has_time_off?(employee_id, week, day)
    !!(fetch_time_off_requests[week] &&
        fetch_time_off_requests[week][employee_id] &&
        fetch_time_off_requests[week][employee_id].collect(&:days).compact.flatten.include?(day))
  end

  # returns time off requests in the form of {WEEK=>{EMPLOYEE_ID=>[list of time off requests], ... more time off requests for this week and groups by employee}, ... more weeks}
  def fetch_time_off_requests
    @fetch_time_off_requests ||= Hash[client.time_off_requests.
        group_by { |item| item.week }.
        map      { |key, items| [key, items.
        group_by { |item| item.employee_id}]}]
  end

  # returns the number of employees required per shift e.g. 2
  def fetch_employees_per_shift
    @fetch_employees_per_shift ||= client.employees_per_shift
  end

  def client
    @client ||= RepliconSchedulerClient.create
  end
end