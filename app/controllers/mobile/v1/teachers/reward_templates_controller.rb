class Mobile::V1::Teachers::RewardTemplatesController < Mobile::V1::Teachers::BaseController
  def index
    @reward_templates = RewardTemplate.order('name')
  end
end
