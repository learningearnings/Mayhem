class CreateHonorRollDeposits < ActiveRecord::Migration
  def change
    create_table :honor_roll_deposits do |t|
      t.integer :student_id
      t.integer :school_id
      t.decimal :amount, :percision => 8, :scale => 2

      t.timestamps
    end
  end
end
