class AddSubdomainToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :store_subdomain, :string
  end
end
