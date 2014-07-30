class AddIndexOnCreatedAtToIntereactions < ActiveRecord::Migration
  def change
    add_index :interactions, :created_at
  end
end
