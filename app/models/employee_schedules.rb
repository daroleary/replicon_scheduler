class EmployeeSchedules
  include Enumerable

  attr_reader :employee_schedules

  def initialize
    @employee_schedules  = {}
  end

  def each(&block)
    @employee_schedules.each do |employee_schedule|
      block.call(employee_schedule)
    end
  end

  def schedule_employee(employee, day)
    @employee_schedules[employee.id] = EmployeeSchedule.new(employee) unless @employee_schedules.has_key?(employee.id)
    @employee_schedules[employee.id].add_day(day)
  end

  def assigned_shifts(day)
    @employee_schedules.select do |_, employee_schedule|
      employee_schedule.days_scheduled.uniq.include?(day)
    end.count
  end
end