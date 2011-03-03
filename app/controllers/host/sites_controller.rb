class Host::SitesController < Host::HostController
  
  def index
    @sites = Site.all.entries
  end  

end
