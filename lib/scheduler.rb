class Scheduler

  attr_reader :schedules

  def initialize(weeks)
    @weeks                 = weeks
    @schedules             = []
  end

  def schedule_employees
    (@weeks).each do |week|
      @schedules << Schedule.new(week).process_schedule
    end
    @schedules
  end

  def fetch_events
    Events.new(schedule_employees).fetch_events
  end

  private

  def client
    @client ||= RepliconSchedulerClient.create
  end
end