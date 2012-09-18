class PeopleController < ApplicationController
  def edit
    @avatars = Avatar.page params[:page]
    @person = Person.find(params[:id])
    render :layout => 'application'
  end

  def get_avatar_results
    @avatars = Avatar.page params[:page]
    render partial: 'avatars'
  end

  def update
    @person = Person.find(params[:id])
    @person.avatar = Avatar.find(params[:avatar_id]) if !params[:avatar_id].blank?
    if (!params[:student][:display_name].blank? && params[:student][:display_name] != @person.display_name) &&  @person.update_attributes(params[:student])
      flash[:notice] = "#{@person.type} profile updated."
      redirect_to main_app.root_path
    else
      @avatars = Avatar.page params[:page]
      flash[:notice] = "#{@person.type} profile not updated."
      render :edit
    end
  end
end
