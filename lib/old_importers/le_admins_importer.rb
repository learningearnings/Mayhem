class LeAdminsImporter < ImporterBase

  def model_class row=''
    LeAdmin
  end

  def header_mapping
    {
      first_name: 'userfname',
      last_name: 'userlname',
    }
  end

  def user_header_mapping
    {
      username: 'username',
      email: 'email',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  def associated_single_classes
    [Spree::User]
  end

end

