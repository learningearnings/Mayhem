class AddCampaign < ActiveRecord::Migration
  def up
    create_table :campaigns do |t|
      t.string :name
      t.string :description
      t.date :eff_date
      t.date :exp_date
      t.timestamps
    end 
  end

  def down
    drop_table :campaigns
  end
end
