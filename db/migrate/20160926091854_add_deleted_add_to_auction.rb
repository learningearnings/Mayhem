class AddDeletedAddToAuction < ActiveRecord::Migration
  def up
    change_table :auctions do |t|
      t.timestamp :deleted_at, :default => nil
    end
  end

  def down
    remove_column :auctions, :deleted_at
    change_table :auctions do |t|
      t.remove :deleted_at
    end
  end
end
