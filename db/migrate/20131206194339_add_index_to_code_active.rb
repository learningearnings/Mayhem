class AddIndexToCodeActive < ActiveRecord::Migration
  def change
    add_index :codes, :active
  end
end
