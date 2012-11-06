class AddRecoveryPasswordToPerson < ActiveRecord::Migration
  def change
    add_column :people, :recovery_password, :string
  end
end
