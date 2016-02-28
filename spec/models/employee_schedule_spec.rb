require 'rails_helper'

RSpec.describe EmployeeSchedule, type: :model do

  let(:employee) { build(:employee) }
  let(:subject) { EmployeeSchedule.new(employee) }

  context '#initialize' do
    it 'days schedule is empty' do
      expect(subject.employee).to eq(employee)
      expect(subject.days_scheduled.empty?).to be_truthy
    end
  end

  context '#add_day' do
    it 'should add days to employee' do
      subject.add_day(2)
      expect(subject.days_scheduled).to eq([2])

      subject.add_day(2)
      subject.add_day(3)
      expect(subject.days_scheduled).to eq([2,3])

      subject.add_day(1)
      expect(subject.days_scheduled).to eq([1,2,3])
    end
  end
end