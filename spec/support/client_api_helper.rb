module ClientApiHelper

  def stub_employee(employee)
    allow_any_instance_of(RepliconSchedulerClient::API).to receive(:employee).and_return(employee)
  end

  def stub_employees(employees)
    allow_any_instance_of(RepliconSchedulerClient::API).to receive(:employees).and_return(employees)
  end
end