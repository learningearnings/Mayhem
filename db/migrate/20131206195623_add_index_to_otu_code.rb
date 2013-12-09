class AddIndexToOtuCode < ActiveRecord::Migration
  def change
    add_index :otu_codes, :code
  end
end
