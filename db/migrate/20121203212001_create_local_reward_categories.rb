class CreateLocalRewardCategories < ActiveRecord::Migration
  def change
    create_table :local_reward_categories do |t|
      t.string :name
      t.string :image_uid
      t.integer :filter_id

      t.timestamps
    end
  end
end
