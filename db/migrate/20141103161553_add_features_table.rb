class AddFeaturesTable < ActiveRecord::Migration
  def up
    create_table :features do |t|
      t.string :description
      t.boolean :shown
      t.timestamps
    end
  end

  def down
    drop_table :features
  end
end
