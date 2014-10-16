class SchoolAdmin < Teacher
  def editable_rewards(school)
    product_ids = (super.pluck(:id) + school.school_product_links.pluck(:spree_product_id)).uniq
    Spree::Product.active.where(id: product_ids).with_property_value('reward_type', 'local')
  end
end
