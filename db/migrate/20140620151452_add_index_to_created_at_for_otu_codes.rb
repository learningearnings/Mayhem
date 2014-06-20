class AddIndexToCreatedAtForOtuCodes < ActiveRecord::Migration
  def change
    add_index :otu_codes, :created_at
  end
end
