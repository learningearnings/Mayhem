class PeopleController < LoggedInController
  def edit
    @avatars = Avatar.page params[:page]
    @person = Person.find(params[:id])
    render :layout => 'application'
  end

  def show
    @person = current_person
    render :layout => 'application'
  end
  
  def get_avatar_results
    @avatars = Avatar.page params[:page]
    render partial: 'avatars'
  end

  def update
    @person = Person.find(params[:id])
    @person.avatar = Avatar.find(params[:avatar_id]) if !params[:avatar_id].blank?
    if params[:teacher][:password].present? && params[:teacher][:password_confirmation].present?
      @person.user.update_attributes(:password => params[:teacher][:password], :password_confirmation => params[:teacher][:password_confirmation])
    end
    if params[:teacher][:email].present?
      @person.user.update_attributes(:email => params[:teacher][:email])
    end
    # If the moniker is either blank or is the existing moniker, don't update
    # it.
    if @person.update_attributes(moniker: params[:moniker])
      flash[:notice] = "#{@person.type} profile updated."
      redirect_to person_path(@person)
    else
      @avatars = Avatar.page params[:page]
      flash[:notice] = "#{@person.type} profile not updated."
      render :edit
    end
  end
end
