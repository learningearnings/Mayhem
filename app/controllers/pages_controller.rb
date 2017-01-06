class PagesController < HighVoltage::PagesController
  layout :layout_for_page
  before_filter :modify_id_by_visitor_type

  def show
    if params[:id] == 'home'
      if Rails.env.production?
        # for not-logged-in users
        unless current_person
          # Strip any subdomains off of the url, leaving us at the unhindered root domain
          if actual_subdomain.present?
            host_without_subdomain = request.env["HTTP_HOST"].gsub(/#{actual_subdomain}\./, '')
            redirect_to "#{request.protocol}#{host_without_subdomain}" and return
          end
        end
      end
    end
    super
  end

  protected
  def layout_for_page
    
    case params[:id]
    when /pdf/
      false
    else
      if current_person
        'application'
      else
        'login'
      end
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
