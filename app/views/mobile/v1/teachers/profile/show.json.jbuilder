json.(@teacher, :id, :first_name, :last_name, :full_name)
json.username @teacher.user.username
json.email @teacher.user.email