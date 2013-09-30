class PeopleController < LoggedInController
  load_and_authorize_resource except: [:get_avatar_results]

  def edit
    @avatars = Avatar.page params[:page]
    render :layout => 'application'
  end

  def show
    render :layout => 'application'
  end

  def get_avatar_results
    @avatars = Avatar.page params[:page]
    render partial: 'avatars'
  end

  def update
    person_attributes = params[:teacher] || params[:student]
    @person.avatar = Avatar.find(params[:avatar_id]) if !params[:avatar_id].blank?
    if person_attributes[:password].present? && person_attributes[:password_confirmation].present?
      @person.user.update_attributes(:password => person_attributes[:password], :password_confirmation => person_attributes[:password_confirmation])
    end
    if person_attributes[:email].present?
      @person.user.update_attributes(:email => person_attributes[:email])
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
