class AddPurchasableToStickers < ActiveRecord::Migration
  def change
    add_column :stickers, :purchasable, :boolean, :default => false
  end
end
