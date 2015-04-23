json.array! @classrooms do |classroom|
  json.(classroom, :id, :name)

  json.students classroom.students do |student|
    json.(student, :id, :first_name, :last_name)
    json.username student.user.username

    json.classrooms student.classrooms do |classroom|
      json.id classroom.id
      json.name classroom.name
    end
  end

  json.goals classroom.classroom_otu_code_categories do |otu_code_category_link|
    json.id otu_code_category_link.otu_code_category.id
    json.name otu_code_category_link.otu_code_category.name
    json.value otu_code_category_link.value
  end

  json.rewards classroom.products do |product|
    json.id product.id
    json.name product.name
    json.description product.description
  end

  json.rewards_count classroom.products.count
end
