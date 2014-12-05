module PagesHelper
  def small_image_pages(product, options={})
    if product.images.empty?
      "No Image"
    else
      image_tag product.images.first.attachment.url(:small), options
    end
  end
  
  def tour_text(id, person)
    if id.start_with?('Menu') && controller.action_name != 'home'
      return ""
    end
    text = Tour.text(id,person)
  end
  
  def intro_tour(step, id, person, options)
    if id.start_with?('Menu') && controller.controller_name != 'home'
      return options
    end
    if params[:tour] || first_time_logged_in || session[:tour] == "Y"
      {'data-step' => step, 'data-intro' => Tour.text(id,person)}.merge!(options)
    else
      options
    end
  end
end
