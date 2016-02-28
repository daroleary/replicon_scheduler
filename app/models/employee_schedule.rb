class EmployeeSchedule
  attr_reader :employee

  def initialize(employee)
    @employee       = employee
    @days_scheduled = []
  end

  def days_scheduled
    @days_scheduled.sort!
  end

  def add_day(day)
    @days_scheduled << day unless @days_scheduled.include?(day)
  end
end