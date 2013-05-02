Spree::ProductsHelper.module_eval do
  def product_description(product)
    if(params[:current_store_id] == Spree::Store.find_by_code('le').try(:id))
      description = product.property("wholesale_description")
      if description.blank?
        description = "A pack of " + product.property("retail_quantity") + " " + product.name
      end
    else
      description = product.description
     end
    raw(description.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>'))
  end

end
