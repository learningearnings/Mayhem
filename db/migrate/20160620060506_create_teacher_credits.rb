class CreateTeacherCredits < ActiveRecord::Migration
  def change
    create_table :teacher_credits do |t|
      t.integer :school_id
      t.integer :teacher_id
      t.string :teacher_name
      t.string :district_guid
      t.decimal :amount, :null => true, :default => nil, :precision => 8, :scale => 2
      t.string :credit_source
      t.timestamps
    end
  end
end
