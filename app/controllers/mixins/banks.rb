module Mixins
  module Banks
    def create_print_bucks
      get_buck_batches
      get_bank
      @bank.create_print_bucks(person, current_school, 'AL', bucks)
    end

    def create_ebucks
      get_buck_batches
      get_bank
      student = Student.find(params[:student][:id])
      issue_ebucks_to_student(student)
    end

    def create_ebucks_for_classroom
      get_buck_batches
      get_bank
      # Override on_success and on_failure
      failed = false # Not thrilled with this...
      @bank.on_success = lambda{ |x| return true }
      @bank.on_failure = lambda{ failed = true }
      classroom = current_person.classrooms.find(params[:classroom][:id])
      OtuCode.transaction do
        classroom.students.each do |student|
          issue_ebucks_to_student(student)
        end
        if failed
          raise ActiveRecord::Rollback
        else
          on_success and return
        end
      end
      # We should only get here if we failed and the transaction rolled back
      on_failure
    end

    def transfer_bucks
      @from_teacher = Person.find(params[:from_teacher_id])
      @to_teacher   = Person.find(params[:to_teacher_id])
      @get_bank
      @bank.transfer_teacher_bucks(current_school, @from_teacher, @to_teacher, params[:transfer_points])
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

    def issue_ebucks_to_student(student)
      @bank.create_ebucks(person, current_school, student, 'AL', BigDecimal(params[:credits][student.id.to_s].gsub(/[^\d]/, '')))
    end
  end
end
