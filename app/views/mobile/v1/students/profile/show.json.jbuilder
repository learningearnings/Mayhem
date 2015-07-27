json.(@student, :id, :first_name, :last_name, :full_name)
json.username @student.user.username
json.email @student.user.email