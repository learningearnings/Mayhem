class SchoolAdmin < Teacher
  def editable_rewards(school)
    product_ids = (super.pluck(:id) + school.school_product_links.pluck(:spree_product_id)).uniq
    Spree::Product.active.where(id: product_ids).with_property_value('reward_type', 'local')
  end
  def my_editable_rewards(school)
  	editable_rewards(school).joins(:spree_product_person_link).where("spree_product_person_links.person_id =?", self.id)
  end
end
