json.array! @goals do |goal|
  json.(goal, :id, :name, :value)
end
