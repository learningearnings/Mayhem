class Add2015SummerGiveawayCampaign < ActiveRecord::Migration
  def up
    Campaign.create(name: '2015_Summer_FB_Giveaway', description: '2015 Summer FB Giveaway')
  end

  def down
    Campaign.delete_all
  end
end
