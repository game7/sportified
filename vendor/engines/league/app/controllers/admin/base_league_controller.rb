class Admin::BaseLeagueController < Admin::AdminController

  before_filter :set_area_info

  def set_area_info
    @breadcrumbs = []
    @breadcrumbs << { :title => "Admin", :url => admin_root_path}
    @breadcrumbs << { :title => "League", :url => admin_league_path}
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
