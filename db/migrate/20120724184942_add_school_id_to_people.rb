class AddSchoolIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :school_id, :integer
  end
end
