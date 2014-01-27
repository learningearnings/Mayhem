class AddGameChallengeableToPeople < ActiveRecord::Migration
  def change
    add_column :people, :game_challengeable, :boolean, :default => false
  end
end
