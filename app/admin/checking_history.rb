ActiveAdmin.register_page "Checking History" do
  menu false

  page_action :get_history, :method => :get do
    person = Person.find params[:person_id]
    @amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: person.checking_account).joins(:transaction).order({ transaction: :created_at}).reverse_order.page(params[:page]).per(10))
  end

end
