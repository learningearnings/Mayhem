class RemoveLockerStickerFromLockerCommandsController < LoggedInController
  def create
    # FIXME: This isn't really a command yet
    link = current_person.locker.locker_sticker_links.find(params[:id])
    link.destroy
    render json: { success: true }
  end
end
