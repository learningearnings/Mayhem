module PeopleHelper
  def first_time_logged_in
    current_person.try(:user).try(:sign_in_count) && current_person.try(:user).try(:sign_in_count) <= 1
  end
  
  def source_from_transaction(transaction)
    transaction.spree_product.try(:person).try(:full_name) || transaction.people.first.try(:full_name) || "none"
  end
  
  def needs_email?
    if current_user
      return current_user.email == nil
    else
      return current_person.user.email == nil
    end
  end
  
  def has_seen_campaign?
    @campaign = Campaign.where(name: '2015_Summer_FB_Giveaway').first
    @cv = CampaignView.where(person_id: current_person.id, campaign_id: @campaign.id).first
    if @cv == nil
      #Do this so the splash is only shown once
      CampaignView.create(person_id: current_person.id, campaign_id: @campaign.id)
    end
    return @cv != nil
  end
  
end
