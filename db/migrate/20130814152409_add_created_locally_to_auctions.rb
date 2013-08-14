class AddCreatedLocallyToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :created_locally, :boolean
  end
end
