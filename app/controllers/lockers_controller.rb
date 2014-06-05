class LockersController < LoggedInController
  def show
    current_person.locker.cleanup_expired_purchases!
    locker_sticker_links = load_locker_sticker_links
    render 'show', locals: { locker_sticker_links: locker_sticker_links }
  end

  def edit
    locker_sticker_links = load_locker_sticker_links
    arel_table         = Sticker.arel_table
    available_sticker_ids = Sticker.
      where(purchasable: false).
      where(
        arel_table[:school_id].eq(nil).
        or(
          arel_table[:school_id].eq(current_school.id)
        )
      ).where(
        arel_table[:min_grade].eq(nil).
        and(
          arel_table[:max_grade].eq(nil)
        ).
        or(
          arel_table[:min_grade].lteq(current_person.grade).
          and(arel_table[:max_grade].gteq(current_person.grade))
        )
      ).pluck(:id)

    purchased_sticker_ids = current_person.sticker_purchases.not_expired.pluck(:sticker_id)

    available_stickers = Sticker.where(id: available_sticker_ids + purchased_sticker_ids)
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
    locker_sticker_links = locker.locker_sticker_links.joins(:sticker)
    render 'shared', locals: { locker_sticker_links: locker_sticker_links, student: student }
  end

  private
  def load_locker_sticker_links
    locker = current_person.locker
    locker.locker_sticker_links.joins(:sticker)
  end
end
