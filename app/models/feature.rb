class Feature < ActiveRecord::Base
  scope :active, where(shown: true)

  attr_accessible :description, :shown, as: :admin

  def to_s
    description
  end
end
