class CreateStateFilterLinks < ActiveRecord::Migration
  def change
    create_table :state_filter_links do |t|
      t.integer :state_id
      t.integer :filter_id

      t.timestamps
    end
  end
end
