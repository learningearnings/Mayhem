class ArrayOfIntegersValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.present?
      record.errors[attribute] << "Must be present"
      return false
    end
    unless value.is_a?(Array)
      record.errors[attribute] << "Must be an array"
      return false
    end
    if value.detect{|x| !x.is_a?(Integer) }
      record.errors[attribute] << "Must be an array of integers"
      return false
    end
  end
end
