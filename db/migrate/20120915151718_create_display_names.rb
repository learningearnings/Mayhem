class CreateDisplayNames < ActiveRecord::Migration
  def change
    create_table :display_names do |t|
      t.string :state
      t.string :display_name
      t.datetime :approved_at
      t.integer :approved_by_id
      t.integer :person_id

      t.timestamps
    end
  end
end
