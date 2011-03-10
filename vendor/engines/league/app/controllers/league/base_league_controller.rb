class League::BaseLeagueController < ApplicationController
  
  before_filter :load_objects
  before_filter :set_breadcrumbs
  before_filter :set_area_navigation

  def load_objects
    
  end

  def set_breadcrumbs
    @breadcrumbs = []
    @breadcrumbs << { :title => "League", :url => league_path}
  end

  def set_area_navigation
    
  end

  def add_new_breadcrumb(title, url = nil)
    @breadcrumbs ||= []
    @breadcrumbs << { :title => title, :url => url }
  end

  def add_area_menu_item(title, url = nil)
    @area_menu_items ||= []
    @area_menu_items << { :title => title, :url => url }
  end

end
