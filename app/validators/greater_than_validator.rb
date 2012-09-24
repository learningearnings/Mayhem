class GreaterThanValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.respond_to?(options[:with])
      record.errors[attribute] << "Must be configured with a symbol that the record responds to"
      return false
    end

    required_value = record.send(options[:with])

    unless value.present?
      record.errors[attribute] << "Must be present"
      return false
    end

    unless value.is_a?(Numeric)
      record.errors[attribute] << "Must be numeric"
      return false
    end

    unless required_value.is_a?(Numeric)
      record.errors[attribute] << "Comparison value must be numeric"
      return false
    end

    record.errors[attribute] << "Must be greater than #{required_value}" unless value > required_value
  end
end
