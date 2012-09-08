class LockersController < LoggedInController
  def show
    locker_sticker_links = load_locker_sticker_links
    render 'show', locals: { locker_sticker_links: locker_sticker_links }
  end

  def edit
    locker_sticker_links = load_locker_sticker_links
    available_stickers = Sticker.all
    render 'edit', locals: { locker_sticker_links: locker_sticker_links, available_stickers: available_stickers }
  end

  private
  def load_locker_sticker_links
    locker = current_person.locker
    locker_sticker_links = locker.locker_sticker_links.joins(:sticker)
    return locker_sticker_links
  end
end
