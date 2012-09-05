require 'active_model'

class ActiveModelCommand
  include ActiveModel::Validations
  include ActiveModel::Naming
  include ActiveModel::Conversion

  # This is so that activemodel acts like we want in the form
  def persisted?
    false
  end
end
