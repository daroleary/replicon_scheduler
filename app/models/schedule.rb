class Schedule
  # TODO: No tests to be found! Are you using these modules and classes included below
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :week, :employees_per_shift, :employee_shifts

  def initialize(week, employees_per_shift)
    @week                = week
    @employees_per_shift = employees_per_shift
    @employee_shifts     = Hash.new {|hash, key| hash[key] = []}
  end

  # Add employee shift to schedule
  # returns false if limit has already reached
  # TODO: Does this handle duplicates
  def add_employee_to_schedule(employee, day)
    return false if employees_per_shift == number_of_shifts_assigned_for(day)
    @employee_shifts[day] << employee
  end

  def number_of_shifts_assigned_for(day)
    employee_shifts[day].count
  end
end