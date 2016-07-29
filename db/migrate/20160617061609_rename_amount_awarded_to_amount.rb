class RenameAmountAwardedToAmount < ActiveRecord::Migration
  def up
  	rename_column :school_credits, :amount_awarded, :amount
  end

  def down
  	rename_column :school_credits, :amount_awarded, :amount
  end
end
