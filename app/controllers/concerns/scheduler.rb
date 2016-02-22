module Scheduler extend ActiveSupport::Concern

  included do
    before_action :process, only: [:index]
  end

  def process
    return if @employees.nil?

    # call the client directly
    # employees_per_shift = get_employees_per_shift
  end

end