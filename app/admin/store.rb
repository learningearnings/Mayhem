ActiveAdmin.register_page "Spree" do

  action_item do
    link_to "Rewards Administraton" , "/store/admin/rewards"
  end

  action_item do
    link_to "Spree Administration", "/store/admin"
  end

  controller do
    skip_before_filter :add_current_store_id_to_params
  end
end
