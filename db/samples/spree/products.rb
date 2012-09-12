# make sure the product images directory exists
FileUtils.mkdir_p "#{Rails.root}/public/spree/products/"

Spree::Asset.all.each do |asset|
  filename = asset.attachment_file_name
  puts "-- Processing image: #{filename}\r"
  if filename.gsub(/^http/)
    asset.attachment = open(filename)
    asset.save
  end
end

fc = FilterConditions.new(:person_classes => ['SchoolAdmin','LeAdmin'] )
factory = FilterFactory.new
wholesale_product_filter = factory.find_or_create_filter(fc)
wholesale_product_filter.save

Spree::Product.all.each do |product|

  # Make all of the sample products visible to everyone (really just school admins)

  SpreeProductFilterLink.create(:filter => wholesale_product_filter, :product_id => product.id)
  Spree::Store.all.each do |s|
    if(s.default && product.property('retail_quantity'))
      product.stores << s
    elsif !s.default && product.property('retail_quantity').nil?
      product.stores << s
    end
  end
end
