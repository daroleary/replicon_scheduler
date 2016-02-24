class EmployeesController < ApplicationController

  before_action :set_client, only: [:index, :show]
  before_action :set_employee, only: [:show]

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

  def fetch_events
    Scheduler.new(Constants::WEEK_NUMBERS).fetch_events
  end
end
