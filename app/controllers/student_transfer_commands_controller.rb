class StudentTransferCommandsController < LoggedInController
  def create
    transfer = StudentTransferCommand.new(params[:student_transfer_command])
    transfer.student_id = current_person.id
    transfer.on_success = method(:on_success)
    transfer.on_failure = method(:on_failure)
    transfer.execute!
  end

  def on_success
    flash[:success] = "Transfer successful."
    redirect_to bank_path
  end

  def on_failure
    flash[:error] = "Invalid transfer."
    redirect_to bank_path
  end
end
