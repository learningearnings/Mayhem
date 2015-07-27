class AddClassroomOtuCodeCategoriesTable < ActiveRecord::Migration
  def up
    create_table :classroom_otu_code_categories do |t|
      t.integer :classroom_id
      t.integer :otu_code_category_id
      t.integer :value
      t.timestamps
    end
  end

  def down
    drop_table :classroom_otu_code_categories
  end
end
