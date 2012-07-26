class CreateClassroomFilterLinks < ActiveRecord::Migration
  def change
    create_table :classroom_filter_links do |t|
      t.integer :classroom_id
      t.integer :filter_id

      t.timestamps
    end
  end
end
