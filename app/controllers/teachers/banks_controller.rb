module Teachers
  class BanksController < Teachers::BaseController
    include Mixins::Banks
    def on_success
      flash[:notice] = 'Bucks created!'
      redirect_to teachers_bank_path
    end

    def on_failure
      flash.now[:error] = 'You do not have enough bucks.'
      render :show
    end

    protected
    def person
      current_person
    end
  end
end
