module Mixins
  module Banks
    def create_print_bucks
      if params[:point1].present? || params[:point5].present? || params[:point10].present?
        get_buck_batches
        get_bank
        # creates and returns bucks array
        batch_name = person.to_s + " Created " + Date.today.to_s
        batch = buck_batch_creator.call(:name => batch_name)
        BuckBatchWorker.perform_async person.id, current_school.id, 'AL', bucks, batch.id
        redirect_to teachers_print_batch_path(batch.id)
      else
        flash[:error] = "Please enter an amount."
        redirect_to main_app.teachers_bank_path
      end
    end

    def create_ebucks
      params[:points] = sanitize_points(params[:points]) if params[:points]
      if params[:points].to_i < 0
        if current_school.can_revoke_credits && current_person.is_a?(SchoolAdmin)
          student = Student.find(params[:student][:id])
          CreditManager.new.teacher_revoke_credits_from_student(current_school, current_person, student, params[:points])
          flash[:notice] = "The points have been deducted from the student account."
        else
          flash[:error] = "You can't enter negative values"
        end
        redirect_to main_app.teachers_bank_path and return
      end

      # TODO: I had to put this in the controller mixin because the error handling assumes a different error.
      # We should refactor this.
      if params[:points].present? && params[:points].to_i > 400
        flash[:error] = "You can not issue more than 400 credits to a student at a time."
        redirect_to main_app.teachers_bank_path and return
      end

      if params[:student][:id].present? && params[:points].present?
        get_buck_batches
        get_bank
        student = Student.find(params[:student][:id])
        reason_id = params["otu_code"]["otu_code_category_id"] if params["otu_code"]
        issue_ebucks_to_student(student, params[:points],reason_id)
        clear_balance_cache!
      else
        flash[:error] = "Please ensure a student is selected and an amount is entered."
        redirect_to main_app.teachers_bank_path
      end
    end

    def create_ebucks_for_students
      #if params[:credits] && params[:credits].values.detect{|x| x.to_i < 0 }
      #  flash[:error] = "You can not enter negative values"
      #  redirect_to :back and return
      #end

      if params[:credits] && params[:credits].values.detect {|x| x.to_s.include?(".") }
        flash[:error] = "You can only enter whole values"
        redirect_to :back and return
      end

      if params[:credits] && params[:credits].values.detect {|x| x.to_s =~  /[^-?\d+(.\d+)?$]/}
        flash[:error] = "You must only enter numerical values"
        redirect_to :back and return
      end

      if params[:credits] && params[:credits].values.detect{|x| x.present?}.present?
        get_buck_batches
        get_bank
        # Override on_success and on_failure
        failed = false # Not thrilled with this...
        @bank.on_success = lambda{ |x| return true }
        @bank.on_failure = lambda{ failed = true }
        OtuCode.transaction do
          students = Student.includes(:person_school_links).where(id: params[:credits].keys, person_school_links: { school_id: current_person.schools.pluck(:id) })
          students.each do |student|
            student_credits = SanitizingBigDecimal(params[:credits][student.id.to_s])
            category_id = params[:credit_categories][student.id.to_s] if params[:credit_categories]
            issue_ebucks_to_student(student, student_credits, category_id) if student_credits > 0
          end
          if failed
            raise ActiveRecord::Rollback
          else
            clear_balance_cache!
            on_success and return
          end
        end
        # We should only get here if we failed and the transaction rolled back
        on_failure
      else
        flash[:error] = "Please ensure a classroom is selected, has students, and an amount is entered."
        redirect_to :back
      end
    end

    def create_ebucks_for_classroom
      if params[:credits] && params[:credits].values.detect{|x| x.to_i < 0 }
        if current_school.can_revoke_credits && current_person.is_a?(SchoolAdmin)
          params[:credits].delete_if do |k, v|
            if v.to_i < 0
              student = Student.find(k)
              CreditManager.new.teacher_revoke_credits_from_student(current_school, current_person, student, v)
            end
          end
        else
          flash[:error] = "You can't enter negative values"
          redirect_to main_app.teachers_bank_path and return
        end
      end

      if params[:classroom] && params[:classroom][:id].present? && params[:credits] && params[:credits].values.detect{|x| x.present?}.present?
        get_buck_batches
        get_bank
        # Override on_success and on_failure
        failed = false # Not thrilled with this...
        @bank.on_success = lambda{ |x| return true }
        @bank.on_failure = lambda{ failed = true }
        classroom = current_person.classrooms.find(params[:classroom][:id])
        OtuCode.transaction do
          classroom.students.each do |student|
            if params[:credits][student.id.to_s].present?
              student_credits = SanitizingBigDecimal(params[:credits][student.id.to_s])
              category_id = params[:credit_categories][student.id.to_s] if params[:credit_categories]
              issue_ebucks_to_student(student, student_credits, category_id) if student_credits.to_i > 0
            end
          end
          if failed
            raise ActiveRecord::Rollback
          else
            clear_balance_cache!
            on_success and return
          end
        end
        # We should only get here if we failed and the transaction rolled back
        on_failure
      else
        flash[:error] = "Please ensure a classroom is selected, has students, and an amount is entered."
        redirect_to main_app.teachers_bank_path
      end
    end
    
    def mixpanel_options
      if current_user and current_school
        district = District.where(guid: current_school.district_guid).last if current_school.district_guid
        if district
          district_name = (district.name.blank? ? "None" : district.name ) 
        else
          district_name = "None"
        end
        @options = {:env => Rails.env, :email => current_user.email, :username => current_user.username, 
                    :first_name => current_user.person.first_name, :last_name => current_user.person.last_name,
                    :grade => current_user.person.try(:grade),
                    :type => current_user.person.type, :school => current_user.person.school.try(:name),
                    :district_guid => (current_school.district_guid.blank? ? "None" : current_school.district_guid ),
                    :district => district_name,                
                    :credits_scope => current_school.credits_scope, :school_synced => current_school.synced? }
      else
        @options = {}
      end
      return @options
    end

    def transfer_bucks
      if params[:from_teacher_id].present? && params[:to_teacher_id].present? && (params[:transfer_points].to_i > 0)
        @from_teacher = Person.find(params[:from_teacher_id])
        @to_teacher   = Person.find(params[:to_teacher_id])
        get_bank
        @bank.transfer_teacher_bucks(current_school, @from_teacher, @to_teacher, params[:transfer_points])
        MixPanelTrackerWorker.perform_async(current_user.id, 'Transfer Credits', mixpanel_options)
        clear_balance_cache!
      else
        flash[:error] = "Please choose a teacher for buck transfer.  Also ensure amount is a positive number."
        redirect_to main_app.teachers_bank_path
      end
    end

    protected
    def get_bank
      @bank = Bank.new
      @bank.on_success = method(:on_success)
      @bank.on_failure = method(:on_failure)
    end

    def bucks
      {:ones => params[:point1].to_i, :fives => params[:point5].to_i, :tens => params[:point10].to_i}
    end

    def get_buck_batches
      @buck_batches = current_person.buck_batches(current_school)
    end

    def issue_ebucks_to_student(student, point_value=params[:points], category_id=nil)
      point_value = SanitizingBigDecimal(point_value) unless point_value.is_a?(BigDecimal)
      @bank.create_ebucks(person, current_school, student, current_school.state.abbr, point_value, category_id)
      MixPanelTrackerWorker.perform_async(current_user.id, 'Send e-Credits', mixpanel_options)
    end

    def sanitize_points(_points)
      _points.gsub(/[^0-9.-]/, "")
    end

    def buck_batch_creator
      ->(params) { BuckBatch.create params }
    end
  end
end
