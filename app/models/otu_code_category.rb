class OtuCodeCategory < ActiveRecord::Base

  attr_accessible :name, :otu_code_type_id, :person_id

  belongs_to :person
  belongs_to :otu_code_type
  has_many :otu_codes

end
