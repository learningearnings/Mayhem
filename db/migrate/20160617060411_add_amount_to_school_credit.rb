class AddAmountToSchoolCredit < ActiveRecord::Migration
  def change
    add_column :school_credits, :total_teachers, :integer
    add_column :school_credits, :amount_awarded, :decimal, :null => true, :default => nil, :precision => 8, :scale => 2
  end
end
