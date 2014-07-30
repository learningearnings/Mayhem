class AddSchoolIdToOtuCodeCategories < ActiveRecord::Migration
  def change
    add_column :otu_code_categories, :school_id, :integer
  end
end
