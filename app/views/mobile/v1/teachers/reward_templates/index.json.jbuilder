json.array! @reward_templates do |reward_template|
  json.(reward_template, :id, :name, :description, :price, :min_grade, :max_grade)
end
