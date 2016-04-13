json.(@classroom, :id, :name)

json.rewards @classroom.products do |product|
  json.(product, :id, :name, :description, :on_hand, :price) unless product.deleted?
  json.image_url (product.images.first.try(:attachment).try(:url) ? product.images.first.try(:attachment).try(:url) : "https://learningearnings.com/assets/noimage/small.png") unless product.deleted?
end

json.students @classroom.students do |student|
  json.(student, :id, :first_name, :last_name, :full_name, :grade, :gender)
  json.username student.user.username
  json.password student.user.password  
  json.email student.user.email
  json.avatar_url  student.avatar.try(:image).try(:url)
end
