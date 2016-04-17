class AddValueToOtuCreditCategory < ActiveRecord::Migration
  def change
    add_column :otu_code_categories, :value, :integer
  end
end
