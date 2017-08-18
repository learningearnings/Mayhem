class PeopleController < LoggedInController
  load_and_authorize_resource except: [:get_avatar_results]

  def edit
    if !current_person.is_a? Student
      @avatars = Avatar.for_teachers.page params[:page]
    else
      @avatars = Avatar.page params[:page]
    end
    render :layout => 'application'
  end

  def show
  end

  def get_avatar_results
    if !current_person.is_a? Student
      @avatars = Avatar.for_teachers.page params[:page]
    else
      @avatars = Avatar.page params[:page]
    end
    render partial: 'avatars'
  end

  def update
    person_attributes = params[:teacher] || params[:student]
    @person.avatar = Avatar.find(params[:avatar_id]) if !params[:avatar_id].blank?
    if person_attributes.present?
      if person_attributes[:password].present? && person_attributes[:password_confirmation].present?
        @person.user.update_attributes(:password => person_attributes[:password], :password_confirmation => person_attributes[:password_confirmation])

        # Devise automatically logs out a user upon password change.
        sign_in(@person.user, bypass: true)
      end
      if person_attributes[:game_challengeable].present?
        @person.update_attributes(:game_challengeable => person_attributes[:game_challengeable])
      end
      if person_attributes[:email].present?
        @person.user.update_attributes(:email => person_attributes[:email])
      end
    end
    if @person.save
      flash[:notice] = "#{@person.type} profile updated."
      redirect_to person_path(@person)
    else
      if !current_person.is_a? Student
        @avatars = Avatar.for_teachers.page params[:page]
      else
        @avatars = Avatar.page params[:page]
      end
      flash[:notice] = "#{@person.type} profile not updated."
      render :edit
    end
  end
end
