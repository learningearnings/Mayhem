class CharitiesController < LoggedInController
  def index
    purchased_charities = Plutus::Transaction.for_person(current_person.id).with_main_account.with_spree_products.merge(Spree::Product.with_property_value('reward_type','charity')).order('plutus_transactions.created_at desc').page(params[:purchased_charities_page]).per(3)
    available_charities = Spree::Product.active.charities.page(params[:available_charities_page]).per(3)
    render 'index', locals: { purchased_charities: purchased_charities, available_charities: available_charities }
  end
  def print
    charities = Plutus::Transaction.where(:id => params[:id]).with_spree_products.merge(Spree::Product.with_property_value('reward_type','charity'))
    render 'print', locals: {charity: charities.first, name: current_person.name}
  end
end
