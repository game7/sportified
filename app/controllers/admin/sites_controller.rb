class Admin::SitesController < Admin::AdminController
  
  before_filter :mark_return_point, :only => :edit
  before_filter :get_site

  def get_site
    @site = Site.current
  end
  
  def edit
    add_breadcrumb("Settings")
  end

  def update
    if @site.update_attributes(params[:site])
      return_to_last_point(:notice => 'Site was successfully updated.')
    end
  end

end
