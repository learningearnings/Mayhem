class ChangeCanDistributeCreditsToDefaultToTrue < ActiveRecord::Migration
  def up
    change_column :people, :can_distribute_credits, :boolean, default: true
  end

  def down
    change_column :people, :can_distribute_credits, :boolean, default: false
  end
end
