class AddLegacyUserIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :legacy_user_id, :integer
  end
end
