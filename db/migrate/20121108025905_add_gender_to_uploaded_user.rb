class AddGenderToUploadedUser < ActiveRecord::Migration
  def change
    add_column(:uploaded_users, :gender, :string)
  end
end
