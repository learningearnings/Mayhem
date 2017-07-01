module PeopleHelper
  def first_time_logged_in
    current_person.try(:user).try(:sign_in_count) && current_person.try(:user).try(:sign_in_count) <= 1
  end
  
  def source_from_transaction(amount)
    transaction = amount.transaction
    if transaction.transaction_description
      amount.try(:account).try(:person_account_link).try(:person).try(:full_name) || "none"
    elsif transaction.otu_code.present? && transaction.otu_code.code.present? && transaction.description == "Issue Printed Credits to Student"
      transaction.otu_code.code
    else
      transaction.spree_product.try(:person).try(:full_name) || transaction.reward_deliverer || transaction.credit_source || "none"
    end  
  end
  
  def category_for_transaction(transaction)
    if commercial_document_link(transaction)
      commercial_document_link(transaction)
    elsif transaction.description.include?("Issue Printed Credits to Student")
      "Printed Credit"
    elsif transaction.description.include?("Revoke Credits for Student")
      "Revoke Credits"
    elsif transaction.description.include?("Perfect Attendance")
      "Perfect Attendance"
    elsif transaction.description.include?("No Tardies")
      "No Tardies"
    elsif  transaction.description.include?("No Infractions")
      "No Infractions"
    end  
          
  end

  def credit_reason(otu_code)
    if otu_code.otu_code_category.present?
      otu_code.otu_code_category.name
    elsif !otu_code.person_school_link.present? && otu_code.transactions.present?
      desc = otu_code.transactions.last.description
      if desc.include?("Perfect Attendance")
        "Perfect Attendance"
      elsif desc.include?("No Tardies")
        "No Tardies"
      elsif  desc.include?("No Infractions")
        "No Infractions"
      elsif desc.include?("Savings Interest Payment")
        "Savings Interest Payment"      
      end 
    else
      "none"
    end  
  end
  
  def method_name
    
  end

  def source_from_otu_code(otu_code)
    transaction = otu_code.transactions.last
    if transaction.present?
      if transaction.transaction_description
        otu_code.student.try(:full_name) || "none"
      else
        transaction.spree_product.try(:person).try(:full_name) || transaction.reward_deliverer || transaction.credit_source || "none"
      end
     else
      "none"
     end 
  end  
  def credit_transactions_title(credit_type)
    case credit_type
    when "total_credit"
      "Total Credits"
    when "deposited"
      "Total Credits Deposited"
    else "undeposited"
      "Total Credits Undeposited"
    end  
  end
  

  def needs_email?
    if session[:defer_email]
      return false
    end
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
      MixPanelTrackerWorker.perform_async(current_user.id, 'Summer 2015 FB Campaign Viewed')
    end
    return @cv != nil
  end

  def otu_codes_credits(student,credit_type,start_date, end_date)
    otu_codes = OtuCode.total_credited(student, start_date, end_date).reverse_order
    if credit_type == "deposited"
      otu_codes = otu_codes.inactive
    elsif @credit_type == "undeposited"
      otu_codes = otu_codes.active
    end
    return otu_codes
  end
end
