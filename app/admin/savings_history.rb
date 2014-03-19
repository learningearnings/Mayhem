ActiveAdmin.register_page "Savings History" do
  menu false

  page_action :get_history, :method => :get do
    person = Person.find params[:person_id]
    @amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: person.savings_account).joins(:transaction).order({ transaction: :created_at }).reverse_order.page(1).per(10))
  end

end
