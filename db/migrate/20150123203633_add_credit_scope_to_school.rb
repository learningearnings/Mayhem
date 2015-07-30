class AddCreditScopeToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :credits_scope, :string
    add_column :schools, :credits_type, :string   
  end
end
