module Teachers
  class RewardTemplatesController < Teachers::BaseController

    def index
      @reward_templates = RewardTemplate.page(params[:page]).per(9)
    end

    def create
      @reward_templates = RewardTemplate
      if params[:reward_templates_search][:search].present?
        @reward_templates = @reward_templates.kinda_matching(params[:reward_templates_search][:search])
      end
      if params[:reward_templates_search][:grade_filter].present?
        @reward_templates = @reward_templates.within_grade(params[:reward_templates_search][:grade_filter])
      end
      @reward_templates = @reward_templates.page(params[:page]).per(9)
      render :partial => "reward_templates_search_results", :locals => {:reward_templates=> @reward_templates}
    end

    def show
      @teachers_reward = Teachers::Reward.new
      @reward_template = RewardTemplate.find(params[:id])
    end

  end
end
