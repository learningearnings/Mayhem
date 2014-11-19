module PeopleHelper
  def source_from_transaction(transaction)
    (transaction.spree_product)?(transaction.spree_product.person.full_name) : ((transaction.people.size > 0)?(transaction.people[0].full_name):"none")
  end
end
