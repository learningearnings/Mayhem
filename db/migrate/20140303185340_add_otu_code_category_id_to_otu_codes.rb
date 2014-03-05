class AddOtuCodeCategoryIdToOtuCodes < ActiveRecord::Migration
  def change
    remove_column :otu_codes, :reason
    add_column :otu_codes, :otu_code_category_id, :integer
  end
end
