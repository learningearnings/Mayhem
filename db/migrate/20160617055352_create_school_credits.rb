class CreateSchoolCredits < ActiveRecord::Migration
  def change
    create_table :school_credits do |t|
      t.integer :school_id
      t.string :school_name
      t.string :district_guid

      t.timestamps
    end
  end
end
