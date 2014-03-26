class AddCanRevokeCreditsToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :can_revoke_credits, :boolean, :default => false
  end
end
