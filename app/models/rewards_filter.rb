module RewardsFilter
  def self.by_classroom(person, products)
    return products unless person.is_a?(Student)

    products_table = Spree::Product.arel_table
    classroom_product_links_table = ClassroomProductLink.arel_table
    people_table = Person.arel_table
    classrooms_table = Classroom.arel_table

    product_ids_query = products_table.project(products_table[:id])
      .join(classroom_product_links_table, Arel::Nodes::OuterJoin)
      .on(classroom_product_links_table[:spree_product_id].eq(products_table[:id]))
      .where(
        classroom_product_links_table[:classroom_id].eq(person.classrooms.pluck(:id)).or(
          classroom_product_links_table[:classroom_id].eq(nil)
        )
      )

    product_ids = ActiveRecord::Base.connection.execute(product_ids_query.to_sql).map{|result| result["id"] }
    Spree::Product.where(id: product_ids)
  end

  def self.ruby_by_classroom(person, products)
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
