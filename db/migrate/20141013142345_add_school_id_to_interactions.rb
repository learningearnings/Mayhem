class AddSchoolIdToInteractions < ActiveRecord::Migration
  def change
    add_column :interactions, :school_id, :integer
  end
end
