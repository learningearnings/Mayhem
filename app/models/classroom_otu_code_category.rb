class ClassroomOtuCodeCategory < ActiveRecord::Base
  belongs_to :classroom
  belongs_to :otu_code_category
end
