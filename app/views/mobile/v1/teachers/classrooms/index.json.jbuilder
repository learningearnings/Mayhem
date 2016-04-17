json.array! @classrooms do |classroom|
  json.(classroom, :id, :name)

  json.students classroom.students do |student|
    json.(student, :id, :first_name, :last_name, :grade, :gender)
    json.username student.user.username
    json.password student.user.password
    json.email student.user.email    
    json.avatar_url student.avatar.try(:image).try(:url)
    json.classrooms student.classrooms do |classroom|
      json.id classroom.id
      json.name classroom.name
    end     
  end

  json.rewards classroom.products do |product|
  	if product.deleted?
  		next
    end
    json.id product.id
    json.name product.name
    json.description product.description
    json.on_hand product.on_hand
    json.price product.price
    json.image_url (product.images.first.try(:attachment).try(:url) ? product.images.first.try(:attachment).try(:url) : "https://learningearnings.com/assets/noimage/small.png")
  end

  json.rewards_count classroom.products.count
end
