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
    validates :classrooms, presence: true

    attr_accessible :name, :price, :classrooms, :image, :end_date, :start_date, :on_hand

    attr_accessor :id, :name, :price, :classrooms,:image, :end_date, :start_date, :spree_product_id
    attr_accessor :on_hand, :spree_product, :teacher, :school

    def initialize params = {}
      @name = params[:name] if params[:name]
      @price = params[:price] if params[:price]
      @on_hand = params[:on_hand] if params[:on_hand]
      @start_date = params[:start_date] if params[:start_date]
      @end_date = params[:end_date] if params[:end_date]
      @image = params[:image].to_i if params[:image]
      @classrooms = params[:classrooms].collect{|c| c.to_i} if params[:classrooms] && params[:classrooms].is_a?(Array)
    end



    def spree_product_id=(id)
      self.spree_product = Spree::Product.find(id)
      @spree_product_id = @id = id
    end

    def spree_product=(p)
      @name = p.name
      @image = p.images.first.attachment.url(:small)
      @price = p.price.to_int
      @start_date = p.available_on
      @end_date = p.deleted_at
      @on_hand = p.on_hand
      @classrooms = p.filter.classrooms.all.collect {|c| [c.id]}.uniq.flatten
      if !@classrooms.any?
        @classrooms = [0]
      end
      # set classrooms to the classrooms from the filter...
    end

    def update(params)
      reward_params = params[:teachers_reward]
      p = Spree::Product.find(reward_params[:id])
      p.name = @name = reward_params[:name]
      p.price = @price = reward_params[:price]
      p.on_hand = @on_hand = reward_params[:on_hand]
      @classrooms = reward_params[:classrooms]
      p.available_on = @start_date = reward_params[:start_date] if reward_params[:start_date]
      p.deleted_on = @end_date = reward_params[:end_date] if reward_params[:end_date]
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
      @price = params[:price] if params[:price]
      @on_hand = params[:on_hand] if params[:on_hand]
      @start_date = params[:start_date] if params[:start_date]
      @end_date = params[:end_date] if params[:end_date]
      @image = params[:image].to_i if params[:image] && params[:image].to_i > 0
      @classrooms = params[:classrooms].collect{|c| c.to_i} if params[:classrooms] && params[:classrooms].is_a?(Array)
      if valid?
        self.save
      end
    end


    def save
      return valid? if !valid?

      if @spree_product_id.nil?
        p = Spree::Product.new
        sppl = SpreeProductPersonLink.new(:person_id => @teacher.id)
      else
        p = Spree::Product.find(@spree_product_id)
        sppl = SpreeProductPersonLink.find_by_product_id(p.id)
      end
      p.name = @name
      p.price = @price
      p.on_hand = @on_hand
      p.available_on = @start_date if @start_date
      p.deleted_at = @end_date if @end_date
      p.save

      if @image.is_a?(Integer) && @image > 0
        lrc = LocalRewardCategory.find(@image)
        if(lrc)
          p.master.images.each do |i| i.destroy end
          image = File.open(lrc.image.path)
          Spree::Image.create({:viewable_id => p.master.id, :viewable_type => 'Spree::Variant',        :alt => "position 2", :attachment => image, :position => 1})
#          p.master.images[0] = i
        end
      end
      p.set_property('reward_type','local')
      p.save
      fc = FilterConditions.new
      if @classrooms.count == 1 && @classrooms[0] == 0  #whole school
        fc.schools << @school
      elsif classrooms.any?
        fc.classrooms << @classrooms if @classrooms.any?  #error otherwise
      end
      ff = FilterFactory.new
      filter = ff.find_or_create_filter(fc)
      spfl = SpreeProductFilterLink.find_by_product_id(@spree_product_id)
      if spfl.nil?
        spfl = SpreeProductFilterLink.new(:filter_id => 0, :product_id => p.id)
      end

      spfl.filter_id = filter.id if spfl
      spfl.save
      sppl.product_id = p.id
      sppl.save
    end


  end
end
