class AddMinAndMaxGradeToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :min_grade, :integer
    add_column :spree_products, :max_grade, :integer
  end
end
