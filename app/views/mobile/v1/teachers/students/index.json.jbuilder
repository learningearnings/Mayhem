json.array! @students do |student|
  json.(student, :id, :first_name, :last_name, :grade, :gender, :classrooms)
  json.username student.user.username
  json.email student.user.email
end
