class Week
  attr_reader :id, :start_date

  def initialize(options = {})
    @id   = options[:id]
    @start_date = options[:start_date]
  end
end