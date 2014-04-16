module Teachers
  class RewardTemplatesController < Teachers::BaseController

    def index
      @reward_templates = RewardTemplate

      @reward_templates = @reward_templates.kinda_matching(params[:q]) if params[:q].present?
      @reward_templates = @reward_templates.within_grade(params[:grade_filter]) if params[:grade_filter].present?
      @reward_templates = @reward_templates.page(params[:page]).per(9)

      render :partial => "reward_templates_search_results", :locals => {:reward_templates=> @reward_templates} if request.xhr?
    end

    def show
      @teachers_reward = Teachers::Reward.new
      @reward_template = RewardTemplate.find(params[:id])
    end
  end
end
