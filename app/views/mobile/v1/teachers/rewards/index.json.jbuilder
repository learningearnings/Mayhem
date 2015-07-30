json.array! @rewards do |reward|
  json.(reward, :id, :name, :description, :count_on_hand)
  json.image_url (product.images.first.try(:attachment).try(:url) ? product.images.first.try(:attachment).try(:url) : "https://learningearnings.com/assets/noimage/small.png")
end
