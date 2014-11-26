require_relative '../../validators/array_of_integers_validator'
module Teachers
  class Reward
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    include ActiveModel::MassAssignmentSecurity
    include ActiveModel::Validations

    validates :name, presence: true
    validates :price, presence: true, numericality: {:greater_than_or_equal_to => 0 }
    validates :on_hand, presence: true, numericality: {:greater_than_or_equal_to => 0 }
    #validates_presence_of :image

    attr_accessible :name, :description, :price, :classrooms, :template_image, :image, :on_hand, :category, :school_id, :classroom_id, :min_grade, :max_grade

    attr_accessor :id, :name, :description, :price, :classrooms, :template_image, :image, :spree_product_id
    attr_accessor :on_hand, :teacher, :school, :category, :school_id, :classroom_id
    attr_accessor :min_grade, :max_grade, :locker_sticker

    delegate :set_property, to: :spree_product

    def initialize params = {}
      @name = params[:name] if params[:name]
      @description = params[:description] if params[:description]
      @price = params[:price] if params[:price]
      @on_hand = params[:on_hand] if params[:on_hand]
      @reward_template = RewardTemplate.find(params[:reward_template_id]) if params[:reward_template_id]
      @image = params[:image] if params[:image]
      @sticker_image = File.open(@image.path) if @image
      @category = params[:category] if params[:category]
      @min_grade = params[:min_grade] if params[:min_grade]
      @max_grade = params[:max_grade] if params[:max_grade]
      @classrooms = Classroom.find(params[:classrooms]) if params[:classrooms]
    end

    def spree_product_id=(id)
      self.spree_product = Spree::Product.find(id)
      @spree_product_id = @id = id
    end

    def product
      Spree::Product.find(spree_product_id)
    end

    def category
      product.taxons.first
    rescue
      false
    end

    def category_id
      category.id
    rescue
      nil
    end

    def spree_product=(p)
      @name = p.name
      @description = p.description
      @price = p.price.to_int
      @on_hand = p.on_hand
      @classrooms = p.classrooms
    end

    def update(params)
      reward_params = params[:teachers_reward]
      p = Spree::Product.find(reward_params[:id])
      p.name = @name = reward_params[:name]
      p.description = @description = reward_params[:description]
      p.price = @price = reward_params[:price]
      p.on_hand = @on_hand = reward_params[:on_hand]
      # update classrooms
      p.save
    end

    def persisted?
      @id ? true : false
    end

    def readonly
      false
    end

    def update_attributes(params,options = {})
      @name = params[:name] if params[:name]
      @description = params[:description] if params[:description]
      @price = params[:price] if params[:price]
      @on_hand = params[:on_hand] if params[:on_hand]
      @image = params[:image] if params[:image]
      @category = params[:category] if params[:category]
      if params[:classrooms]
        @classrooms = Classroom.find(params[:classrooms]) if params[:classrooms]
      else
        @classrooms = []
      end
      if valid?
        self.save
      end
    end

    def spree_product
      return nil if @spree_product_id.nil?
      Spree::Product.find(@spree_product_id)
    end

    def whole_school?
      @classrooms && @classrooms.empty?
    end

    def save
      return false unless valid?

      if spree_product.nil?
        p = Spree::Product.new
        sppl = SpreeProductPersonLink.new(:person_id => @teacher.id)
      else
        p = spree_product
        sppl = SpreeProductPersonLink.find_by_product_id(p.id)
      end

      p.name = @name
      p.description = @description
      p.price = @price
      p.on_hand = @on_hand
      p.available_on = Time.now
      p.store_ids = [@school.store.id]
      p.min_grade = @min_grade
      p.max_grade = @max_grade
      p.fulfillment_type = locker_sticker ? "Locker Sticker" : "local"
      p.sticker_image = @sticker_image
      p.save

      @spree_product_id = p.id

      if @image.present?
        p.images.destroy_all if p.images.present?
        p.images.create(attachment: @image)
      end

      if @reward_template.present? && @reward_template.image.present?
        p.images.destroy_all if p.images.present?
        # FIX ME
        # This isn't copying the image over at all
        p.images.create(attachment: File.open(@reward_template.image.path))
      end

      p.set_property('reward_type', 'local')
      p.taxons = Spree::Taxon.where(:id => @category)
      p.save

      if @classrooms.present?
        p.school_product_links.delete_all
        p.classroom_product_links.delete_all
        @classrooms.each do |classroom|
          ClassroomProductLink.create(spree_product_id: p.id, classroom_id: classroom.id)
        end
      else
        p.classroom_product_links.delete_all
        p.school_product_links.delete_all
        SchoolProductLink.create(school_id: @school.id, spree_product_id: p.id)
      end

      sppl.product_id = p.id
      sppl.save
    end
  end
end
