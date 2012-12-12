module SchoolAdmins
  class BanksController < SchoolAdmins::BaseController
    layout 'resp_application'
    include Mixins::Banks
    def show
      @teacher = current_person
    end

    def on_success batch_id
      flash[:notice] = 'Bucks created!'
      if batch_id.nil?
        redirect_to school_admins_bank_path
      else
        redirect_to teachers_print_batch_path(batch_id,"pdf")
      end
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
