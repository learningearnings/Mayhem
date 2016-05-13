module Teachers
  class RewardsController < Teachers::BaseController
    # GET /teachers/rewards
    # GET /teachers/rewards.json
    def index
      if current_person.is_a?(SchoolAdmin) and params[:all_rewards] == "Y"
        temp_params = params
        temp_params[:current_school] = current_school
        temp_params[:searcher_current_person] = current_person
        @searcher = Spree::Search::Filter.new(temp_params)
        @products = @searcher.retrieve_products
        @teachers = @products.includes(:person).map(&:person).compact.uniq         
        @products = filter_by_rewards_for_teacher(@products, params[:teacher], params[:reward_type])      
        @teachers_rewards = @products.order("spree_products.name").page(params[:page]).per(9)
      else
        @rewards = current_person.editable_rewards(current_school)
        @teachers = @rewards.includes(:person).map(&:person).compact.uniq
        @rewards = filter_by_rewards_for_teacher(@rewards, params[:teacher] , params[:reward_type])  
        @teachers_rewards = @rewards.order("spree_products.name").page(params[:page]).per(9)        
      end
      respond_to do |format|
        format.html # index.html.haml
        format.json { render json: @teachers_rewards }
      end
    end

    def refund_teacher_reward
      @reward_delivery = RewardDelivery.find(params[:id])
      @reward_delivery.refund_purchase
      @product = RewardDelivery.find(params[:id]).reward.variant.product
      redirect_to teachers_reward_path(@product.id)
    end

    # GET /teachers/rewards/1
    # GET /teachers/rewards/1.json
    def show
      @teachers_reward = Teachers::Reward.new
      @teachers_reward.teacher = current_person
      @teachers_reward.school = current_school
      @teachers_reward.spree_product_id = params[:id]
      @teachers_reward.classrooms = @teachers_reward.classrooms.map(&:id)
      @line_items = @teachers_reward.product.master.line_items.page(params[:page]).per(10)

      respond_to do |format|
        format.html # show.html.haml
        format.json { render json: @teachers_reward }
      end
    end

    # GET /teachers/rewards/new
    # GET /teachers/rewards/new.json
    def new
      @teachers_reward = Teachers::Reward.new
      #where(:filter_id => [session[:filters]]).order(:name).collect { |lrc| [lrc.id,lrc.image.url,lrc.name]}

      respond_to do |format|
        format.html # new.html.haml
        format.json { render json: @teachers_reward }
      end
    end

    # GET /teachers/rewards/1/edit
    def edit
      @teachers_reward = Teachers::Reward.new
      @teachers_reward.teacher = current_person
      @teachers_reward.school = current_school
      @teachers_reward.spree_product_id = params[:id]
      @teachers_reward.classrooms = @teachers_reward.classrooms.map(&:id)
    end

    # POST /teachers/rewards
    # POST /teachers/rewards.json
    def create
      unless params[:reward_scope] == 'specific_classrooms' && !params[:teachers_reward][:classrooms].present?
        @teachers_reward = Teachers::Reward.new(params[:teachers_reward])
        @teachers_reward.teacher = current_person
        @teachers_reward.school = current_school

        respond_to do |format|
          if @teachers_reward.save
            format.html { redirect_to teachers_rewards_path, notice: "Your Reward \"#{@teachers_reward.name}\"was successfully created." }
            format.json { render json: @teachers_reward, status: :created, location: @teachers_reward }
          else
            format.html { render action: "new" }
            format.json { render json: @teachers_reward.errors, status: :unprocessable_entity }
          end
        end
      else
        @teachers_reward = Teachers::Reward.new
        flash[:error] = 'You did not select a classroom for the reward. Hit the back button and try again.'
        render :new
      end
    end

    # PUT /teachers/rewards/1
    # PUT /teachers/rewards/1.json
    def update
      @teachers_reward = Teachers::Reward.new
      @teachers_reward.teacher = current_person
      @teachers_reward.school = current_school
      @teachers_reward.spree_product_id = params[:id]
      if params[:take_ownership]
        @teachers_reward.product.person = current_person
      end
      respond_to do |format|
        if @teachers_reward.update_attributes(params[:teachers_reward])
          format.html { redirect_to teachers_rewards_path, notice: "Your Reward \"#{@teachers_reward.name}\"was successfully updated." }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @teachers_reward.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /teachers/rewards/1
    # DELETE /teachers/rewards/1.json
    def destroy
      product = Spree::Product.find(params[:id])
      product.destroy

      respond_to do |format|
        format.html { redirect_to teachers_rewards_url }
        format.json { head :no_content }
      end
    end
  end
end
