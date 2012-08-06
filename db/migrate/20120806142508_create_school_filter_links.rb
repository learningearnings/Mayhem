class CreateSchoolFilterLinks < ActiveRecord::Migration
  def change
    create_table :school_filter_links do |t|
      t.integer :school_id
      t.integer :filter_id

      t.timestamps
    end
  end
end
