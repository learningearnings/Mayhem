class Mobile::V1::Students::ClassroomsController < Mobile::V1::Students::BaseController
  def index
    @classrooms = current_person.classrooms_for_school(current_school)   
    @checking_history = Plutus::Amount.where(account_id: current_person.checking_account).order(" id desc ")
    @debits = @checking_history.select { | trans | trans.type.to_s == "Plutus::DebitAmount"} 
    @credits = @checking_history.select { | trans | trans.type.to_s == "Plutus::CreditAmount"} 
    @debit_balance = 0
    @debits.each do  | debit | 
      @debit_balance = @debit_balance + debit.amount 
    end
    @credit_balance = 0
    @credits.each do  | credit | 
      @credit_balance = @credit_balance + credit.amount 
    end  
  end
  

  def show
    @classroom = Classroom.find(params[:id])
  end
end
