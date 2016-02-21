class RuleDefinition
  attr_reader :id, :value, :description

  def initialize(options = {})
    @id   = options[:id]
    @value = options[:value]
    @description = options[:description]
  end
end