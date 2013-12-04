class AddStiIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :sti_id, :integer
  end
end
