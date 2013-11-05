module Mixins
  module Banks
    def create_print_bucks
      if params[:point1].present? || params[:point5].present? || params[:point10].present?
        get_buck_batches
        get_bank
        @bank.create_print_bucks(person, current_school, 'AL', bucks)
      else
        flash[:error] = "Please enter an amount."
        redirect_to :back
      end
    end

    def create_ebucks
      params[:points] = sanitize_points(params[:points]) if params[:points]
      # TODO: I had to put this in the controller mixin because the error handling assumes a different error.
      # We should refactor this.
      if params[:points].present? && params[:points].to_i > 400
        flash[:error] = "You can not issue more than 400 credits to a student at a time."
        redirect_to :back and return
      end

      unless SanitizingBigDecimal(params[:points]) > 0
        flash[:error] = "You must enter greater than 0 credits"
        redirect_to :back and return
      end

      if params[:student][:id].present? && params[:points].present?
        get_buck_batches
        get_bank
        student = Student.find(params[:student][:id])
        issue_ebucks_to_student(student)
      else
        flash[:error] = "Please ensure a student is selected and an amount is entered."
        redirect_to :back
      end
    end

    def create_ebucks_for_classroom
      if params[:classroom][:id].present? && params[:credits] && params[:credits].values.detect{|x| x.present?}.present?
        get_buck_batches
        get_bank
        # Override on_success and on_failure
        failed = false # Not thrilled with this...
        @bank.on_success = lambda{ |x| return true }
        @bank.on_failure = lambda{ failed = true }
        classroom = current_person.classrooms.find(params[:classroom][:id])
        OtuCode.transaction do
          classroom.students.each do |student|
            student_credits = SanitizingBigDecimal(params[:credits][student.id.to_s])
            issue_ebucks_to_student(student, student_credits) if student_credits > 0
          end
          if failed
            raise ActiveRecord::Rollback
          else
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

    def transfer_bucks
      if params[:from_teacher_id].present? && params[:to_teacher_id].present? && (params[:transfer_points].to_i > 0)
        @from_teacher = Person.find(params[:from_teacher_id])
        @to_teacher   = Person.find(params[:to_teacher_id])
        get_bank
        @bank.transfer_teacher_bucks(current_school, @from_teacher, @to_teacher, params[:transfer_points])
      else
        flash[:error] = "Please choose a teacher for buck transfer.  Also ensure amount is a positive number."
        redirect_to :back
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

    def issue_ebucks_to_student(student, point_value=params[:points])
      point_value = SanitizingBigDecimal(point_value) unless point_value.is_a?(BigDecimal)
      @bank.create_ebucks(person, current_school, student, current_school.state.abbr, point_value)
    end

    def sanitize_points(_points)
      _points.gsub(/[^0-9.]/, "")
    end
  end
end
