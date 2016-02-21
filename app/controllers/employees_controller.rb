class EmployeesController < ApplicationController
  before_action :set_client, only: [:index, :show]
  before_action :set_employee, only: [:show]

  # GET /employees
  # GET /employees.json
  def index
    @employees = @client.employees.map do |employee|
      Employee.new(employee)
    end
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:name)
  end

  def set_client
    @client ||= RepliconSchedulerClient.create
  end

  def set_employee
    @employee = Employee.new(@client.employee(params[:id]))
  end
end
