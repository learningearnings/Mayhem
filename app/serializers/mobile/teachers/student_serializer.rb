class Mobile::Teachers::StudentSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :full_name, :username, :email

  def username
    object.user.username
  end

  def email
    object.user.email
  end
end
