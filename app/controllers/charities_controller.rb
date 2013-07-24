class CharitiesController < LoggedInController
  def index
    charities = Plutus::Transaction.for_person(current_person.id).with_main_account.with_spree_products.merge(Spree::Product.with_property_value('reward_type','charity')).order('plutus_transactions.created_at desc').page(params[:page]).per(4)
    render 'index', locals: { charities: charities }
  end
  def print
    charities = Plutus::Transaction.where(:id => params[:id]).with_spree_products.merge(Spree::Product.with_property_value('reward_type','charity'))
    render 'print', locals: {charity: charities.first}
  end
end
