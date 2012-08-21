class StudentTransferCommandsController < LoggedInController
  def create
    transfer = StudentTransferCommand.new(params[:student_transfer_command])
    transfer.student_id = current_person.id
    if transfer.valid?
      transfer.execute!
      flash[:success] = "Transfer successful."
    else
      flash[:error] = "Invalid transfer."
    end
    redirect_to bank_path
  end
end
