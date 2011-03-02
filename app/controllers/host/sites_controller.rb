class Host::SitesController < ApplicationController
  
  def index
    @sites = Site.all.entries
  end
  
end
