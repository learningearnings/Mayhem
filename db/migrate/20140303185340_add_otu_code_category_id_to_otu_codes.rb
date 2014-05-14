class AddOtuCodeCategoryIdToOtuCodes < ActiveRecord::Migration
  def change
    add_column :otu_codes, :otu_code_category_id, :integer
  end
end
