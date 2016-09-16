json.array! @students do |student|
  json.(student, :id, :first_name, :last_name, :grade, :gender)
  json.avatar_url student.avatar.try(:image).try(:url)
end
