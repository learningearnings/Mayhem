json.array! @purchases do |purchase|
  json.(purchase, :id)
end
