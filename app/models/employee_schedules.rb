class EmployeeSchedules
  attr_reader :employee_schedules

  def initialize
    @employee_schedules  = {}
  end

  def schedule_employee(employee, day)
    @employee_schedules[employee.id] = EmployeeSchedule.new(employee) unless @employee_schedules.has_key?(employee.id)
    @employee_schedules[employee.id].add_day(day)
  end

  def assigned_shifts(day)
    @employee_schedules.values.select do |employee_schedule|
      employee_schedule.days_scheduled.uniq.include?(day)
    end.count
  end

  def to_json
    @employee_schedules.values.map do |employee_schedule|
      {employee_id: employee_schedule.employee.id,
       schedule: employee_schedule.days_scheduled}
    end
  end
end