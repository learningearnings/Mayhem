class UpdateLockerStickerLinkPositionsCommandsController < LoggedInController
  def create
    # This isn't really a command yet...
    locker_sticker_link = current_person.locker.locker_sticker_links.find(params[:id])
    locker_sticker_link.x = params[:x]
    locker_sticker_link.y = params[:y]
    locker_sticker_link.save
    render nothing: true
  end
end
