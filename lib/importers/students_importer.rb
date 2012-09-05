class StudentsImporter < PeopleImporter

  def model_class row=''
    Student
  end

  def header_mapping
    {
      first_name: 'FName',
      last_name: 'LName',
      grade: 'GR',
    }
  end

  def user_header_mapping
    {
      username: 'UF_Network_Login',
      password: 'UF_Network_Password',
      password_confirmation: 'UF_Network_Password'
    }
  end
end
