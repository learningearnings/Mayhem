class AddGradesToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :min_grade, :integer
    add_column :auctions, :max_grade, :integer
  end
end
