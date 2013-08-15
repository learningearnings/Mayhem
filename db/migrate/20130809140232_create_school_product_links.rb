class CreateSchoolProductLinks < ActiveRecord::Migration
  def change
    create_table :school_product_links do |t|
      t.integer :school_id
      t.integer :spree_product_id

      t.timestamps
    end
  end
end
