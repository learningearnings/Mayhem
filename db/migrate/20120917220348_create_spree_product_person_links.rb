class CreateSpreeProductPersonLinks < ActiveRecord::Migration
  def change
    create_table :spree_product_person_links do |t|
      t.integer :product_id
      t.integer :person_id

      t.timestamps
    end
  end
end
