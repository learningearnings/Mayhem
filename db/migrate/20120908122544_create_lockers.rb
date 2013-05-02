class CreateLockers < ActiveRecord::Migration
  def change
    create_table :lockers do |t|
      t.integer :person_id
      t.timestamps
    end
  end
end
