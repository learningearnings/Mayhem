module Mixins
  module Banks
    def create_print_bucks
      bank = get_bank
      bank.create_print_bucks(person, current_school, 'AL', bucks)
    end

    def create_ebucks
      bank = get_bank
      student = Student.find(params[:student][:id])
      bank.create_ebucks(person, current_school, student, 'AL', BigDecimal(params[:points].gsub(/[^\d]/, '')))
    end

    def transfer_bucks
      @from_teacher = Person.find(params[:from_teacher_id])
      @to_teacher   = Person.find(params[:to_teacher_id]) 
      bank = get_bank
      bank.transfer_teacher_bucks(current_school, @from_teacher, @to_teacher, params[:points])
    end

    protected
    def get_bank
      bank = Bank.new
      bank.on_success = method(:on_success)
      bank.on_failure = method(:on_failure)
      bank
    end

    def bucks
      {:ones => params[:point1].to_i, :fives => params[:point5].to_i, :tens => params[:point10].to_i}
    end
  end
end
