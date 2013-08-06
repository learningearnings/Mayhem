class PagesController < HighVoltage::PagesController
  layout :layout_for_page
  before_filter :modify_id_by_visitor_type

  protected
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
