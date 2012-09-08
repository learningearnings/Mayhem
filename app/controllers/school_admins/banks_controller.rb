module SchoolAdmins
  class BanksController < SchoolAdmins::BaseController
    include Mixins::Banks

    def on_success
      flash[:notice] = 'Bucks created!'
      redirect_to school_admins_bank_path
    end

    def on_failure
      flash.now[:error] = 'You do not have enough bucks.'
      render :show
    end

    protected
    def person
      @person ||= if params[:teacher] && params[:teacher][:id].present?
        Teacher.find(params[:teacher][:id])
      else
        current_person
      end
    end
  end
end
