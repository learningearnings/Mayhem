json.array! @rewards do |reward|
  json.(reward, :id, :name, :description, :count_on_hand)
end
