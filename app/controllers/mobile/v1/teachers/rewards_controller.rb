class Mobile::V1::Teachers::RewardsController < Mobile::V1::Teachers::BaseController
  def index
    @rewards = current_person.editable_rewards(current_school).order('name')
  end

  def show
    @reward = Spree::Product.find(params[:id])
  end

  def create
    @reward = Teachers::Reward.new(params[:reward])
    @reward.teacher = current_person
    @reward.school = current_school
    if @reward.save
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end

  def update
    @reward = Spree::Product.find(params[:id])
    @reward.name = params[:reward][:name]
    @reward.description = params[:reward][:description]
    if @reward.save
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end
end
