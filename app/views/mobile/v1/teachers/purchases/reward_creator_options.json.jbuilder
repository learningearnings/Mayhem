json.array! @people do |person|
  json.(person, :id, :first_name, :last_name, :grade, :gender)
  json.avatar_url person.avatar.try(:image).try(:url)	
end
