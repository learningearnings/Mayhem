class PagesController < HighVoltage::PagesController
  layout :layout_for_page
  before_filter :modify_id_by_visitor_type

  def show
    if params[:id] == 'home'
      strip_subdomains unless current_person
    end
    super
  end

  protected
  # Strip any subdomains off of the url, leaving us at the unhindered root domain
  def strip_subdomains
    if actual_subdomain.present?
      host_without_subdomain = request.env["HTTP_HOST"].gsub(/#{actual_subdomain}\./, '')
      redirect_to "#{request.protocol}#{host_without_subdomain}"
    end
  end

  def layout_for_page
    case params[:id]
    when /pdf/
      false
    else
      'application'
    end
  end

  def modify_id_by_visitor_type
    case params[:visitor_type]
    when 'teacher'
      params[:id] = "#{params[:id]}_teachers"
    when 'parent'
        params[:id] = "#{params[:id]}_parents"
    end
  end
end
