class PagesController < ApplicationController
  
  def show
    redirect_to first_live_child.url if @page.skip_to_first_child and (first_live_child = @page.children.live.asc(:position).first).present?
  end
  
  private
  
  def load_objects
    find_page
  end
  
  def find_page
    @page = Page.find_by_path(params[:path])
    @page ||= Page.new(:title => 'Welcome') unless params[:path]
  end
  
  def set_breadcrumbs
    @page.ancestors_and_self.each do |parent|
      add_breadcrumb parent.title_in_menu.presence || parent.title, get_page_url(parent)
    end unless @page.root?
  end
  
  def set_area_navigation
    has_children = false
    @page.children.in_menu.each do |child|
      has_children = true
      add_area_menu_item child.title_in_menu.presence || child.title, get_page_url(child)
    end
    unless @page.root? or has_children
      @page.siblings_and_self.in_menu.each do |sibling|
        add_area_menu_item sibling.title_in_menu.presence || sibling.title, get_page_url(sibling)        
      end
    end
  end
  
end