module Teachers
  class Reward
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :name, :price, :classrooms,:image, :end_date, :start_date, :spree_product_id
    attr_accessor :on_hand, :spree_product

    def spree_product_id=(id)
      p = Spree::Product.find(id)
      self.spree_product = p
    end

    def spree_product=(p)
      @name = p.name
      @image = p.images.first.attachment.url(:small)
      @price = p.price.to_int
      @start_date = p.available_on
      @end_date = p.deleted_at
      @classrooms = p.filter.classrooms.all.collect {|c| [c.id]}
      if !@classrooms.any?
        @classrooms = [0]
      end
      # set classrooms to the classrooms from the filter...
    end

    def update(params)
      reward_params = params[:teachers_reward]
      @name = reward_params[:name]
      @price = reward_params[:price]
      @start_date = reward_params[:start_date]
      @end_date = reward_params[:end_date]
    end


    def persisted?
      false
    end

    def save
      # save this one
    end

  end
end
