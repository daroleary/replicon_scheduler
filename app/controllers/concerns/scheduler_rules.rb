module SchedulerRules extends ActiveSupport::Concern

  def employees_per_shift
    return if @employees.nil? ||
              @rule_definitions.nil?

    fetch_shift_rule_value_for('EMPLOYEES_PER_SHIFT')
  end

  private

  def fetch_shift_rule_value_for(key)
    rule_definition = @rule_definitions.find{|model| model.value == key}
    @shift_rules.find{|model| model.rule_id == rule_definition.id}.value
  end

end