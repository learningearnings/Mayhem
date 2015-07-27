json.(@reward, :id, :name, :description)
json.image_url (product.images.first.try(:attachment).try(:url) ? product.images.first.try(:attachment).try(:url) : "https://learningearnings.com/assets/noimage/small.png")
