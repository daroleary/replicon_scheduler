require 'rails_helper'
require 'replicon_scheduler_client/client'

RSpec.describe Scheduler, type: :class do

  let(:subject) { Scheduler.new }

  describe '#process_schedule' do
    it 'should get schedule' do

      allow(subject).to receive(:fetch_employees) { get_employees }
      allow(subject).to receive(:fetch_employees_per_shift) { 1 }

      actual_result = subject.schedule_employees([23])

      puts actual_result
    end
  end

  def employee_schedule(employee_id, day)
    {employee_id: employee_id, day: day}
  end

  def get_employees
    [employee(1, 'some.one.name'),
     employee(2, 'some.two.name')]
  end

  def employee(id, name)
    Employee.new(id: id,
                 name: name)
  end

end