module PagesHelper
  def small_image_pages(product, options={})
    if product.images.empty?
      "No Image"
    else
      image_tag product.images.first.attachment.url(:small), options
    end
  end
  
  def intro_tour(step, id, person, options)
    #only highlight menu option of current page
    if id.start_with?('menu') 
      page = id.split("_")[1]
      if !request.path.include?(page)
        return options
      end
    end
    if params[:tour] || first_time_logged_in
      {'data-step' => step, 'data-intro' => tour_text(id,person)}.merge!(options)
    else
      return options
    end
  end
  
  def tour_text(id, person)
    if person.is_a?(Student)
      text = t("tour.student." + id)
    elsif person.is_a?(SchoolAdmin)
      text = (person.try(:school).try(:synced?)) ? t("tour.school_admin.integrated." + id) : t("tour.school_admin.non_integrated." + id)
    elsif person.is_a?(Teacher)
      text = (person.try(:school).try(:synced?)) ? t("tour.teacher.integrated." + id) : t("tour.teacher.non_integrated." + id)
    else
      text = "Unknown person type: #{person.type}"
    end
    if text.include?("translation_missing")
      text = "No intro text found for id: #{id} and role: #{person.type} and integrated: #{person.try(:school).try(:synced?)}"
    end
    return text
  end
  
end
