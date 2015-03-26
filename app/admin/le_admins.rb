ActiveAdmin.register LeAdmin do
  form :partial => "form"
  filter :first_name
  filter :last_name
  filter :username
  filter :email

  index do
    selectable_column
    column :first_name
    column :last_name
    column :username 
    column :email
    default_actions
  end

  show do |ad|
    attributes_table do
      row :first_name
      row :last_name
      row :username 
      row :email
    end
    active_admin_comments
  end



  member_action :set_password, :method => :post do
  end

  controller do

    def create
      @le_admin = LeAdmin.new(params[:le_admin], :as => :admin)
      if @le_admin.save
        @le_admin.user.update_attributes(:username => params[:le_admin][:username], :password => params[:le_admin][:password], :password_confirmation => params[:le_admin][:password_confirmation], :email => params[:le_admin][:email])
        @le_admin.activate
        @le_admin.user.spree_roles << Spree::Role.where(name: 'admin').first
        flash[:notice] = 'LeAdmin Created.'
        redirect_to admin_le_admin_path(@le_admin)
      else
        flash[:error] = 'LeAdmin Error.'
        render 'form'
      end
 
    end
  end


end
