json.(@parent, :id, :first_name, :last_name, :full_name)
json.username @parent.user.username
json.email @parent.user.email
json.relationship @parent.relationship
json.phone @parent.phone
