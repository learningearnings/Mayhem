json.(@student, :id, :first_name, :last_name, :full_name)
json.username @student.user.username
json.email @student.user.email
json.avatar_url @student.avatar.try(:image).try(:url)
json.avatars @avatars do | avatar |
	if avatar.image.blank? or avatar.image.url.blank?
  		next
    end
    json.id avatar.id
    json.description avatar.description
    json.url avatar.image.url
end