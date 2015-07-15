class AddTourEvent < ActiveRecord::Migration
  def up
    create_table :tour_events do |t|
      t.integer :person_id
      t.string :page
      t.string :event_name
      t.string :tour_name
      t.integer :tour_step
      t.date    :date      
      t.timestamps
    end    
  end

  def down
    drop_table :tour_events
  end
end
