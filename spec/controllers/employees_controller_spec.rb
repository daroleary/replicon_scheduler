require 'rails_helper'
require 'replicon_scheduler_client/models/employee'

RSpec.describe EmployeesController, type: :controller do

  # let(:client) { RepliconSchedulerClient.create }
  let(:employee) { Employee.new(id: 1, name: Faker::Name.name) }
  let(:employees) { [employee] }
  let(:valid_session) { {} }

  before(:each) do
    stub_employee(employee)
    stub_employees([employee])
  end

  describe '#index' do
    it 'should get to index' do

      get :index

      expect(response.status).to eq(200)
      expect(assigns(:employees)).to eq([employee])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested employee as @employee' do
      get :show, {id: employee.id}

      expect(response.status).to eq(200)
      expect(assigns(:employee)).to eq(employee)
    end
  end

  def employee_schedule(employee_id, day)
    {employee_id: employee_id, day: day}
  end
end
