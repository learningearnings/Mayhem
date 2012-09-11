class CreateSpreeProductFilterLinks < ActiveRecord::Migration
  def change
    create_table :spree_product_filter_links do |t|
      t.integer :product_id
      t.integer :filter_id

      t.timestamps
    end
  end
end
