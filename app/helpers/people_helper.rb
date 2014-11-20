module PeopleHelper
  def source_from_transaction(transaction)
    if transaction.spree_product.try(:person)
      transaction.spree_product.person.full_name
    elsif (transaction.people.size > 0)
      transaction.people[0].full_name
    else
      "none"
    end
  end
end
