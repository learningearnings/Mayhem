class LockersController < LoggedInController
  def show
    current_person.locker.cleanup_expired_purchases!
    locker_sticker_links = load_locker_sticker_links
    render 'show', locals: { locker_sticker_links: locker_sticker_links }
  end

  def edit
    locker_sticker_links = load_locker_sticker_links
    available_stickers = Sticker.available_for_school_and_person(current_school, current_person)
    render 'edit', locals: { locker_sticker_links: locker_sticker_links, available_stickers: available_stickers }
  end

  def friends
    @grademates = current_person.grademates
    render layout: false
  end

  def share
    @message = StudentShareLockerMessageCommand.new
    @grademates = current_person.grademates
    render layout: false
  end

  def shared
    student = Student.find(params[:id])
    locker = student.locker
    locker.cleanup_expired_purchases!    
    locker_sticker_links = locker.locker_sticker_links.joins(:sticker)
    render 'shared', locals: { locker_sticker_links: locker_sticker_links, student: student }
  end

  private
  def load_locker_sticker_links
    locker = current_person.locker
    locker.locker_sticker_links.joins(:sticker)    
  end
end
