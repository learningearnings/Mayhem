class CreateClassroomProductLinks < ActiveRecord::Migration
  def change
    create_table :classroom_product_links do |t|
      t.integer :classroom_id
      t.integer :spree_product_id
      t.timestamps
    end
  end
end
