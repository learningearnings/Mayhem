class AddStatusToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :canceled, :boolean
  end
end
