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
