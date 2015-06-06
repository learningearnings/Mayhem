json.(@classroom, :id, :name)

json.rewards @classroom.products do |product|
  json.(product, :id, :name, :description, :on_hand, :price) unless product.deleted?
end

json.goals @classroom.classroom_otu_code_categories do |otu_code_category_link|
  json.name otu_code_category_link.otu_code_category.name
  json.value otu_code_category_link.value
end

json.students @classroom.students do |student|
  json.(student, :id, :first_name, :last_name, :full_name, :grade, :gender)
  json.username student.user.username
  json.password student.user.password  
  json.email student.user.email
end
