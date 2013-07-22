class RemoveImageFromAvatar < ActiveRecord::Migration
  def up
    remove_column :avatars, :image
  end

  def down
    add_column :avatars, :image, :string
  end
end
