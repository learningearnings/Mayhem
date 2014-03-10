class OtuCodeType < ActiveRecord::Base

  attr_accessible :name

  has_many :otu_code_categories

end
