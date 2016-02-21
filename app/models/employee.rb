class Employee
  attr_reader :name, :id

  def initialize(options = {})
    @id   = options[:id]
    @name = options[:name]
  end
end
