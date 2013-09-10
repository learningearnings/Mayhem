class AddLockerStickerToLockerCommandsController < LoggedInController
  def create
    # FIXME: This isn't really a command yet
    sticker = Sticker.find(params[:id])
    link = current_person.locker << sticker
    link.update_attributes(x: params[:x], y: params[:y])
    render json: { id: link.id }
  end
end
