class StudentsImporter < PeopleImporter

  def model_class row=''
    Student
  end

  def header_mapping
    {
      first_name: 'First',
      last_name: 'Last',
      grade: 'Grade',
      gender: 'Gender'
    }
  end

  def user_header_mapping
    {
      username: 'Username',
      password: 'Password'
      #password_confirmation: 'UF_Network_Password'
    }
  end
end
