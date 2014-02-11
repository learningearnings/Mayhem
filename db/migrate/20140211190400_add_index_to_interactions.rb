class AddIndexToInteractions < ActiveRecord::Migration
  def change
    add_index :interactions, :person_id
  end
end
