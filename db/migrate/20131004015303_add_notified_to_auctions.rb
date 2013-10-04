class AddNotifiedToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :notified, :boolean, :default => false
  end
end
