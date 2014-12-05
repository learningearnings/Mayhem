module PeopleHelper

  def source_from_transaction(transaction)
    transaction.spree_product.try(:person).try(:full_name) || transaction.people.first.try(:full_name) || "none"
  end

  def first_time_logged_in
    current_person.try(:user).try(:sign_in_count) && current_person.try(:user).try(:sign_in_count) <= 1
  end

end
