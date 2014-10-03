class ClassroomActivator
  attr_reader :classroom

  def initialize(classroom_id)
    @classroom = Classroom.find(classroom_id)
  end

  def execute!
    return true if classroom.inactive?
    Classroom.transaction do
      classroom.activate
      activate_orphaned_products
    end
    classroom.reload.inactive?
  end

  private

  def activate_orphaned_products
    classroom.products.with_property_value("reward_type", "local").readonly(false).each do |product|
      if product.classroom_product_links.count == 1
        product.update_attribute(:deleted_at, nil)
      end
    end
  end
end
