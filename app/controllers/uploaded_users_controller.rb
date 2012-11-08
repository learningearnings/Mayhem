class UploadedUsersController < LoggedInController
  before_filter :ensure_le_admin!

  def bulk_upload
  end

  def index
    @uploaded_users = UploadedUser.all
  end

  def edit
    @uploaded_user = UploadedUser.find(params[:id])
  end

  def show
    @uploaded_user = UploadedUser.find(params[:id])
  end

  def new
    @uploaded_user = UploadedUser.new
  end

  def update
    @uploaded_user = UploadedUser.find(params[:id])
    if @uploaded_user.update_attributes(params[:uploaded_user])
      flash[:notice] = "User Updated"
      redirect_to uploaded_users_path
    else
      render :action => 'edit'
    end


  end
  def create
    @uploaded_user = UploadedUser.new(params[:uploaded_user])
    if @uploaded_user.save
      redirect_to uploaded_user_path(@uploaded_user), :notice => "User created!"
  else
      render :action => 'new'
    end
  end

  def destroy
    uploaded_user = UploadedUser.find(params[:id])
    uploaded_user.destroy
    flash[:notice] = "You just deleted a user"
    redirect_to uploaded_users_path
  end


end
