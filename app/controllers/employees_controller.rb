class EmployeesController < ApplicationController
  WEEK_NUMBERS = [23, 24, 25, 26]

  before_action :set_client, only: [:index, :show]
  before_action :set_employee, only: [:show]
  after_action :fetch_events, only: [:index, :show]

  # GET /employees
  # GET /employees.json
  def index
    @employees = @client.employees
    #TODO: inconsistently gets set, need to fix
    @events = fetch_events
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    #TODO: fails first time, need to fix
    @events = fetch_events
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:name)
  end

  #TODO move to a util method
  def set_client
    @client ||= RepliconSchedulerClient.create
  end

  def set_employee
    @employee = @client.employee(params[:id])
  end

  def fetch_week(week_number)
    @client.week(week_number)
  end

  #TODO: add tests
  def fetch_events
    @events = Events.new(fetch_week(WEEK_NUMBERS.first).start_date)
    schedules = Scheduler.new.schedule_employees(WEEK_NUMBERS)
    schedules.each do |schedule|
      start_date = fetch_week(schedule.week).start_date
      schedule.employee_shifts.map do |day,employee_shift|
        employee_shift.each do |employee|
          @events.add_employee_event(employee, start_date+(day-1))
        end
      end
    end
    @events
  end
end
