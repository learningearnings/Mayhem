json.array! @classrooms do |classroom|
  json.(classroom, :id, :name)
end
