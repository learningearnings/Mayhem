class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :poll_choice_id
      t.integer :person_id
      t.timestamps
    end
  end
end
