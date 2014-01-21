module PagesHelper
  def small_image_pages(product, options={})
    if product.images.empty?
      "No Image"
    else
      image_tag product.images.first.attachment.url(:small), options
    end
  end
end
