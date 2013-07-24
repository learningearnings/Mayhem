module Teachers
  class RewardsController < Teachers::BaseController
    # GET /teachers/rewards
    # GET /teachers/rewards.json
    def index
      @teachers_rewards = Spree::Product.with_property_value('reward_type','local').joins(:spree_product_person_link).where(:spree_product_person_link => {:person_id => current_person.id}).page(params[:page]).per(9)
#      @teachers_rewards = Spree::Product.with_property_value('reward_type','local').page(params[:page]).per(9)

      respond_to do |format|
        format.html # index.html.haml
        format.json { render json: @teachers_rewards }
      end
    end

    # GET /teachers/rewards/1
    # GET /teachers/rewards/1.json
    def show
      @teachers_reward = nil # Teachers::Reward.find(params[:id])

      respond_to do |format|
        format.html # show.html.haml
        format.json { render json: @teachers_reward }
      end
    end

    # GET /teachers/rewards/new
    # GET /teachers/rewards/new.json
    def new
      @teachers_reward = Teachers::Reward.new
      @reward_categories = LocalRewardCategory.where(:filter_id => [session[:filters]]).order(:name).collect { |lrc| [lrc.id,lrc.image.url,lrc.name]}

      respond_to do |format|
        format.html # new.html.haml
        format.json { render json: @teachers_reward }
      end
    end

    # GET /teachers/rewards/1/edit
    def edit
      @reward_categories = LocalRewardCategory.where(:filter_id => [session[:filters]]).order(:name).collect { |lrc| [lrc.id,lrc.image.url,lrc.name]}
      @teachers_reward = Teachers::Reward.new
      @teachers_reward.teacher = current_person
      @teachers_reward.school = current_school
      @teachers_reward.spree_product_id = params[:id]
    end

    # POST /teachers/rewards
    # POST /teachers/rewards.json
    def create
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
    end

    # PUT /teachers/rewards/1
    # PUT /teachers/rewards/1.json
    def update
      @teachers_reward = Teachers::Reward.new
      @teachers_reward.teacher = current_person
      @teachers_reward.school = current_school
      @teachers_reward.spree_product_id = params[:id]
      respond_to do |format|
        if @teachers_reward.update_attributes(params[:teachers_reward])
          format.html { redirect_to teachers_rewards_path, notice: "Your Reward \"#{@teachers_reward.name}\"was successfully updated." }
          format.json { head :no_content }
        else
          @reward_categories = LocalRewardCategory.where(:filter_id => [session[:filters]]).order(:name).collect { |lrc| [lrc.id,lrc.image.url,lrc.name]}
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
