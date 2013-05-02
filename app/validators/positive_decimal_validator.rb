class PositiveDecimalValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.present?
      record.errors[attribute] << "Must be present"
      return false
    end
    unless value.is_a?(BigDecimal)
      record.errors[attribute] << "Must be a BigDecimal"
      return false
    end
    record.errors[attribute] << "Must be positive and non-zero" unless value > BigDecimal('0')
  end
end
