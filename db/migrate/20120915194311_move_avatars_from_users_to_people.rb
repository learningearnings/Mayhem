class MoveAvatarsFromUsersToPeople < ActiveRecord::Migration
  def up
    rename_table :user_avatar_links, :person_avatar_links;
    rename_column :person_avatar_links, :user_id, :person_id
  end

  def down
    rename_table :person_avatar_links, :user_avatar_links
    rename_column :user_avatar_links, :person_id, :user_id
  end
end
