ActiveAdmin.register StiLinkToken, as: "Chalkable Link Token" do
  menu :parent => "Chalkable", :priority => 1
  index :title => 'Chalkable Link Tokens' do
    column :created_at
    column :updated_at
    column :district_guid
    column :api_url
    column :link_key
    column :username
    column :status
  end  
end
