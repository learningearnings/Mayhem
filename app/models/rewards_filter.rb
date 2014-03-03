module RewardsFilter
  def self.by_classroom(person, products)
    return products unless person.is_a?(Student)
    classrooms = person.classrooms.pluck(:id)
    products.reject! do |product|
      # Products that have no classrooms should not be rejected
      next if product.classrooms.empty?
      # If there is an intersection between the products classrooms and my classrooms, don't reject
      (product.classrooms.pluck(:id) & classrooms).any? ? false : true
    end
    # To fix pagination we need an active record relation, not an array
    # Why are you laughing?
    products = Spree::Product.where(:id => products.map(&:id))
  end
end
