json.(@student, :id, :first_name, :last_name, :full_name, :grade, :gender)

json.classrooms @student.classrooms do |classroom|
  json.(classroom, :id, :name)
end

json.username @student.user.username
json.email @student.user.email
