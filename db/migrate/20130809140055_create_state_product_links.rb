class CreateStateProductLinks < ActiveRecord::Migration
  def change
    create_table :state_product_links do |t|
      t.integer :state_id
      t.integer :spree_product_id

      t.timestamps
    end
  end
end
