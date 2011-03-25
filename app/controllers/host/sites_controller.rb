class Host::SitesController < Host::HostController
  
  def set_breadcrumbs
    super
    add_breadcrumb( "Sites", host_sites_path )
  end

  def index
    @sites = Site.all.entries
  end  

end
