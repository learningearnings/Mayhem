ActiveAdmin.register Interaction do
  config.filters = false

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
end
