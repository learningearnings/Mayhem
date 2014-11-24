module PeopleHelper
  def source_from_transaction(transaction)
    transaction.spree_product.try(:person).try(:full_name) || transaction.people.first.try(:full_name) || "none"
  end
end
