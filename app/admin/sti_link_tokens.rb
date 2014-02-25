ActiveAdmin.register StiLinkToken do
  menu :parent => "STI", :priority => 1
  index do
    column :created_at
    column :updated_at
    column :district_guid
    column :api_url
    column :link_key
    column :username
  end
end
