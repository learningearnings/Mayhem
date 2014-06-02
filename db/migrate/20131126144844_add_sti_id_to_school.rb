class AddStiIdToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :sti_id, :integer
  end
end
