class AddStickerIdToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :sticker_id, :integer    
  end
end
