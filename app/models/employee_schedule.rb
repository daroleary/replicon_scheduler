class EmployeeSchedule
  attr_reader :employee

  def initialize(employee)
    @employee       = employee
    @days_scheduled = []
  end

  def ==(another_employee_schedule)
    self.employee == another_employee_schedule.employee
    self.days_scheduled == another_employee_schedule.days_scheduled
  end

  def days_scheduled
    @days_scheduled.sort!
  end

  def add_day(day)
    @days_scheduled << day unless @days_scheduled.include?(day)
  end
end