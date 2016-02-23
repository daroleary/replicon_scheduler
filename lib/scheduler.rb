class Scheduler

  def schedule_employees(weeks)
    @schedules          = []
    employees_per_shift = fetch_employees_per_shift
    employees           = fetch_employees

    weeks.each do |week|
      schedule = Schedule.new(week, employees_per_shift)
      (1..7).each do |day|
        employees.each do |employee|
          break unless schedule.add_employee_to_schedule(employee, day)
        end
      end
      @schedules << schedule
    end
    @schedules
  end

  def client
    @client ||= RepliconSchedulerClient.create
  end

  def fetch_employees
    @client.employees.uniq
  end

  def fetch_employees_per_shift
    @client.employees_per_shift
  end
end