class AddCampaignStatus < ActiveRecord::Migration
  def up
    create_table :campaign_views do |t|
      t.integer :person_id
      t.integer :campaign_id
      t.timestamps
    end    
  end

  def down
    drop_table :campaign_views
  end
end
