Spree::UsersController.class_eval do

  def edit
    @avatars = Avatar.page params[:page]
    render :layout => 'application'
    @user = Spree::User.find(params[:id])
  end

  def get_avatar_results
    @avatars = Avatar.page params[:page]
    render partial: 'spree/users/avatars'
  end

  def update
    @user = Spree::User.find(params[:id])
    if @user.save
      if params[:avatar_id]
        if avatar_link = UserAvatarLink.find_by_user_id(@user.id)
          avatar_link.update_attributes(:avatar_id => params[:avatar_id])
        else
          UserAvatarLink.create(:avatar_id => params[:avatar_id], :user_id => @user.id)
        end
      end
      flash[:notice] = 'User updated.'
      redirect_to main_app.root_path
    else
      flash[:notice] = 'User not updated.'
      render :new
    end
  end


end
