module NavHelper
  def students_path
    if current_person.synced?
      main_app.edit_teachers_bulk_students_path
    else
      main_app.teachers_bulk_students_path
    end
  end
end
