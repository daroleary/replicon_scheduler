class Schedule
  attr_reader :week, :shifts

  def initialize(week)
    @week                = week
    @employees_per_shift = fetch_employees_per_shift
    @shifts     = Hash.new {|hash, key| hash[key] = []}
  end

  def fetch_schedule
    (days_in_week).each do |day|
      add_employees_to_schedule(day)
    end
    self
  end

  private

  # Add employee shift to schedule
  # returns false if limit has already reached
  # TODO: Does this handle duplicates
  def add_employees_to_schedule(day)
    fetch_employees.each do |employee|
      @shifts[day] << employee unless @employees_per_shift == number_of_shifts_assigned_for(day)
    end
  end

  def number_of_shifts_assigned_for(day)
    @shifts[day].count
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