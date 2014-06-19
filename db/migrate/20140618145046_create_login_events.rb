class CreateLoginEvents < ActiveRecord::Migration
  def change
    create_table :login_events do |t|
      t.integer :user_id
      t.integer :school_id
      t.string :user_type

      t.timestamps
    end
  end
end
