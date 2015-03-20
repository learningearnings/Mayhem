class LockersController < LoggedInController
  def show
    locker_sticker_links = load_locker_sticker_links
    MixPanelWorker.new.track(current_user.id, 'View Locker')
    render 'show', locals: { locker_sticker_links: locker_sticker_links }
  end

  def edit
    locker_sticker_links = load_locker_sticker_links
    available_stickers = Sticker.all
    MixPanelWorker.new.track(current_user.id, 'Decorate Locker')
    render 'edit', locals: { locker_sticker_links: locker_sticker_links, available_stickers: available_stickers }
  end

  def friends
    @grademates = current_person.grademates
    render layout: false
  end

  def share
    @message = StudentShareLockerMessageCommand.new
    @grademates = current_person.grademates
    MixPanelWorker.new.track(current_user.id, 'Share Locker')
    render layout: false
  end

  def shared
    student = Student.find(params[:id])
    locker = student.locker
    locker_sticker_links = locker.locker_sticker_links.joins(:sticker)
    MixPanelWorker.new.track(current_user.id, 'View Shared Locker')
    render 'shared', locals: { locker_sticker_links: locker_sticker_links, student: student }
  end

  private
  def load_locker_sticker_links
    locker = current_person.locker
    locker_sticker_links = locker.locker_sticker_links.joins(:sticker)
    return locker_sticker_links
  end
end
