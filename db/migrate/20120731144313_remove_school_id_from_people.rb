class RemoveSchoolIdFromPeople < ActiveRecord::Migration
  def change
    remove_column :people, :school_id
  end
end
