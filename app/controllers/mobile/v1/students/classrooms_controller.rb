class Mobile::V1::Students::ClassroomsController < Mobile::V1::Students::BaseController
  def index
    current_person = Student.find(181357)
    @classrooms = current_person.classrooms_for_school(current_school)   
    @recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.checking_account).joins(:transaction).order({ transaction: :created_at}))
    @recent_savings_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.savings_account).joins(:transaction).order({ transaction: :created_at}))
    @unredeemed_bucks = current_person.otu_codes.active    
    @checking_balance = number_with_precision(current_person.checking_balance, precision: 2, delimiter: ',')
    @savings_balance = number_with_precision(current_person.savings_balance, precision: 2, delimiter: ',')
  end
  

  def show
    @classroom = Classroom.find(params[:id])
  end
end
