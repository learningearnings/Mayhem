module ApplicationHelper
  # In the context of views, the current_person gets decoratred
  # NOTE: I'm not sure if this is confusing, since current_person will be different depending on the context (controller or view)
  # For now I think it makes sense, but we can rethink if it confuses anyone...
  def current_person
    if current_user
      PersonDecorator.decorate(current_user.person)
    end
  end
end
