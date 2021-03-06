require 'roo'

class UploadedUsersController < LoggedInController
  before_filter :ensure_le_admin!

  def bulk_upload
    if params[:bulk_upload] && params[:bulk_upload][:the_file]
      if params[:bulk_upload][:the_file].original_filename.include?('.xls')
        tmpfile = "/tmp/xxx-" + params[:bulk_upload][:the_file].original_filename
        File.open(tmpfile,'w') do |f|
          f.write(params[:bulk_upload][:the_file].tempfile.read)
        end
        csv_file = convert(tmpfile)
      end
    end
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

  def check_valid
    error_count = 0
    UploadedUser.all.each do |u|
      @new_person = eval(u.type).new(first_name:u.first_name, last_name:u.last_name, username:u.username, grade:u.grade, email:u.email, gender:u.gender)
      unless @new_person.valid?
        u.message = @new_person.errors.messages.to_yaml
        u.deny
        error_count += 1
      end
      u.approve
    end
    if error_count
      flash[:notice] = error_count.to_s + " records have errors"
      redirect_to uploaded_users_path
    end
  end

private
  def convert(file_path)
    begin
      file_basename = File.basename(file_path, ".xls")
      xls = Excel.new(file_path, false, :ignore)
      xls.to_csv("/tmp/#{file_basename}.csv")
      file_path = "/tmp/#{file_basename}.csv"
    end
  end
end
