class CreateUserAvatarLinks < ActiveRecord::Migration
  def change
    create_table :user_avatar_links do |t|
      t.integer :user_id
      t.integer :avatar_id
      t.timestamps
    end
    add_index(:user_avatar_links, :created_at)
  end
end
