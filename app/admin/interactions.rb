ActiveAdmin.register Interaction do
  index do
    column :id
    column :person do |interaction|
      interaction.person
    end
    column :page
    column :ip_address
    column :elapsed_milliseconds
    column :created_at
  end
  controller do
    skip_before_filter :add_current_store_id_to_params
  end

end
