class PagesController < ApplicationController
  
  def show  
    redirect_to first_live_child.url if @page.skip_to_first_child and (first_live_child = @page.children.live.asc(:position).first).present?
  end
  
  private
  
  def load_objects
    find_page
  end
  
  def find_page
    @page = Page.with_path(params[:path]).first    
  end
  
  def set_breadcrumbs
    @page.ancestors_and_self.each do |parent|
      add_breadcrumb parent.title_in_menu.presence || parent.title, page_friendly_path(parent.path)
    end
  end
  
  def set_area_navigation
    #@area_name = @page.title
    @page.children.each do |child|
      add_area_menu_item child.title_in_menu.presence || child.title, page_friendly_path(child.path)
    end
  end
end