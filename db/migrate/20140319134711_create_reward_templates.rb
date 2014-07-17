class CreateRewardTemplates < ActiveRecord::Migration
  def change
    create_table :reward_templates do |t|
      t.string :name
      t.text :description
      t.decimal :price, :percision => 8, :scale => 2

      t.timestamps
    end
  end
end
