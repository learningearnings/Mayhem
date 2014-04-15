class Schools::RewardExclusionsController < SchoolAdmins::BaseController
  def index
    @reward_exclusions = current_school.reward_exclusions
  end

  def new
    temp_params = params
    temp_params[:current_school] = current_school
    @searcher = Spree::Search::Filter.new(temp_params)
    @products = @searcher.retrieve_products
  end

  def create
    current_school.reward_exclusions.find_or_create_by_product_id(params[:product_id])
    redirect_to new_schools_reward_exclusion_path, notice: "Exclusion added successfully."
  end

  def destroy
    exclusion = current_school.reward_exclusions.find_by_id(params[:id])
    exclusion.destroy
    redirect_to schools_reward_exclusions_path, notice: "Exclusion removed successfully."
  end
end
