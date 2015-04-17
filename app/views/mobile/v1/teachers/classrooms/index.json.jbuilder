json.array! @classrooms do |classroom|
  json.(classroom, :id, :name)

  json.students classroom.students do |student|
    json.(student, :id, :first_name, :last_name)
    json.username student.user.username
  end

  json.goals classroom.classroom_otu_code_categories do |otu_code_category_link|
    json.name otu_code_category_link.otu_code_category.name
    json.value otu_code_category_link.value
  end

  json.rewards_count classroom.products.count

  json.goals_count classroom.otu_code_categories.count
end
