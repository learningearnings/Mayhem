class AddLockerStickerToLockerCommandsController < LoggedInController
  def create
    # FIXME: This isn't really a command yet
    sticker = Sticker.find(params[:id])
    link = current_person.locker << sticker
    render json: { id: link.id }
  end
end
