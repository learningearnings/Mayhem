class AddPersonIdToAuctionsTable < ActiveRecord::Migration
  def change
    add_column :auctions, :person_id, :integer
  end
end
