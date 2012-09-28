class CreateMonikers < ActiveRecord::Migration
  def change
    create_table :monikers do |t|
      t.string :state
      t.string :moniker
      t.datetime :approved_at
      t.integer :approved_by_id
      t.integer :person_id

      t.timestamps
    end
  end
end
