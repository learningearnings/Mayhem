class District < ActiveRecord::Base
  attr_accessible :guid, :name, :alsde_study
  validates_presence_of :guid, :name
end
