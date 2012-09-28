module ApplicationHelper
  # In the context of views, the current_person gets decoratred
  # NOTE: I'm not sure if this is confusing, since current_person will be different depending on the context (controller or view)
  # For now I think it makes sense, but we can rethink if it confuses anyone...
  def current_person
    if current_user && current_user.person
      PersonDecorator.decorate(current_user.person)
    end
  end
  
  def active_if(visitor_type)
    # We don't set visitor_type for students, but we want the helper to be sensible
    visitor_type = '' if visitor_type == 'student'
    if params[:visitor_type].to_s == visitor_type
      'active'
    end
  end

  def current_school
    School.find(session[:current_school_id])
  end

  def buck_link(buck)
    link_to 'Redeem Buck', "/bank/redeem_bucks", buck
  end

  def filter_widget
    render "shared/filter/filter_widget"
  end

  def image_processor
    ::Dragonfly[:images]
  end

  def render_reward_highlights products
    render 'shared/rewards_highlights', products: products
  end
end
