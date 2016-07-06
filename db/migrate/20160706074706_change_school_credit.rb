class ChangeSchoolCredit < ActiveRecord::Migration
  def up
  	change_column :school_credits, :amount, :decimal, :default => 0.0, :null => false,:precision => 10, :scale => 2
  end
  def down
  	change_column :school_credits, :amount, :decimal, :default => nil, :null => true, :precision => 10, :scale => 2
  end
end
