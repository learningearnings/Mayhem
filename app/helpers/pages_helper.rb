module PagesHelper
  def small_image_pages(product, options={})
    if product.images.empty?
      "No Image"
    else
      image_tag product.images.first.attachment.url(:small), options
    end
  end
  
  def intro_tour(step, id, person, options)
    if id.start_with?('menu_') && controller.controller_name != 'home'
      return options
    end
    if params[:tour] || first_time_logged_in || session[:tour] == "Y"
      {'data-step' => step, 'data-intro' => tour_text(id,person)}.merge!(options)
    else
      options
    end
  end
  
  def tour_text(id, person)
    if person.is_a?(Student)
      text = t("tour.student." + id)
    elsif person.is_a?(SchoolAdmin)
      text = (person.try(:school).try(:synced?)) ? t("tour.school_admin.integrated." + id) : t("tour.school_admin.non-integrated." + id)
    elsif person.is_a?(Teacher)
      text = (person.try(:school).try(:synced?)) ? t("tour.teacher.integrated." + id) : t("tour.teacher.non-integrated." + id)
    else
      text = "No intro text found for id: #{id} and role: #{person.type} and integrated: #{person.try(:school).try(:synced?)}"
    end
  end
end
