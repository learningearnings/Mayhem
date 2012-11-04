ActiveAdmin.register LeAdmin do

  show do |le_admin|
    render "show"
  end


  member_action :set_password, :method => :post do
  end


end
