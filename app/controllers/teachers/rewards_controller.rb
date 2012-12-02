module Teachers
  class RewardsController < Teachers::BaseController
    layout 'resp_application'
    # GET /teachers/rewards
    # GET /teachers/rewards.json
    def index
#      @teachers_rewards = Spree::Product.with_property_value('reward_type','local').joins(:spree_product_person_link).where(:spree_product_person_link => {:person_id => current_person.id})
      @teachers_rewards = Spree::Product.with_property_value('reward_type','local')

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

      respond_to do |format|
        format.html # new.html.haml
        format.json { render json: @teachers_reward }
      end
    end

    # GET /teachers/rewards/1/edit
    def edit
#      @teachers_reward = nil # Teachers::Reward.find(params[:id])
      @teachers_reward = Teachers::Reward.new
      @teachers_reward.spree_product_id = params[:id]
    end

    # POST /teachers/rewards
    # POST /teachers/rewards.json
    def create
      @teachers_reward = nil # Teachers::Reward.new(params[:teachers_reward])

      respond_to do |format|
        if @teachers_reward.save
          format.html { redirect_to @teachers_reward, notice: 'Reward was successfully created.' }
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
      @teachers_reward = nil # Teachers::Reward.find(params[:id])

      respond_to do |format|
        if @teachers_reward.update_attributes(params[:teachers_reward])
          format.html { redirect_to @teachers_reward, notice: 'Reward was successfully updated.' }
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
    @teachers_reward = nil # Teachers::Reward.find(params[:id])
      @teachers_reward.destroy

      respond_to do |format|
        format.html { redirect_to teachers_rewards_url }
        format.json { head :no_content }
      end
    end
  end
end
