class AddSvgToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :svg_file_name, :string
  end
end
