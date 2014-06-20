class AddIndexToPersonIdOnOtuCodes < ActiveRecord::Migration
  def change
    add_index :otu_codes, :person_school_link_id
  end
end
