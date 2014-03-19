ActiveAdmin.register SiteSetting do

  controller do
    def create
      if SiteSetting.last.present?
        @site_setting = SiteSetting.last
      else
        @site_setting = SiteSetting.new
      end

      if @site_setting.update_attributes(params[:site_setting])
        flash[:notice] = 'Site Setting updated'
        redirect_to admin_site_setting_path(@site_setting)
      else
        flash[:error] = 'There was a problem updating the site setting.'
        render :edit
      end
    end
  end


end
