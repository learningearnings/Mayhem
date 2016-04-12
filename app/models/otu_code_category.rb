class OtuCodeCategory < ActiveRecord::Base

  attr_accessible :name, :otu_code_type_id, :person_id, :school_id

  belongs_to :person
  belongs_to :school
  belongs_to :otu_code_type
  has_many :classroom_otu_code_categories
  has_many :classrooms, through: :classroom_otu_code_categories
  has_many :otu_codes

  #default_scope { joins(:otu_code_type).order("otu_code_types.name, otu_code_categories.name") }

  def school_wide?
    person_id.nil?
  end

end
