module Teachers
  class Reward
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :name, :price, :classrooms, :end_date, :start_date, :image, :spree_product_id
    attr_accessor :spree_product

    def spree_product_id=(id)
      p = Spree::Product.find(id)
      self.spree_product = p
    end

    def spree_product=(p)
      @name = p.name
      @image = p.images.first.attachment.url(:small)
      @price = p.price.to_ixo
      @start_date = p.available_on
      @end_date = p.deleted_at
      # set classrooms to the classrooms from the filter...
    end

    def persisted?
      false
    end

  end
end
