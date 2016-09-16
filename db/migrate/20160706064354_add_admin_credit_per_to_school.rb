class AddAdminCreditPerToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :admin_credit_percent, :integer, default: 5
  end
end
