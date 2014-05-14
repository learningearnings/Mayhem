class CreateOtuCodeCategories < ActiveRecord::Migration
  def change
    create_table :otu_code_categories do |t|
      t.string :name
      t.integer :otu_code_type_id
      t.integer :person_id

      t.timestamps
    end
  end
end
