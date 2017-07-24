class StudentTransferCommandsController < LoggedInController
  def create
    transfer = StudentTransferCommand.new(params[:student_transfer_command])
    transfer.student_id = current_person.id
    transfer.on_success = method(:on_success)
    transfer.on_failure = method(:on_failure)
    transfer.execute!
    if params[:student_transfer_command][:direction] == "checking_to_savings"
      #MixPanelTrackerWorker.perform_async(current_user.id, 'Transfer Credits to Savings', mixpanel_options)   
    else
      #MixPanelTrackerWorker.perform_async(current_user.id, 'Transfer Credits to Checking', mixpanel_options)
    end  
    clear_balance_cache!
  end

  def on_success
    flash[:success] = "Transfer successful."
    redirect_to bank_path
  end

  def on_failure
    flash[:error] = "You tried to transfer more credits than you currently have. You cannot transfer more than you have in your account.."
    redirect_to bank_path
  end
end
