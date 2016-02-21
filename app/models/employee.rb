class Employee
  attr_reader :id, :name

  def initialize(options = {})
    @id   = options[:id]
    @name = options[:name]
  end
end
