class PagesController < ApplicationController
  before_filter :verify_admin, :except => [:show]
  before_filter :find_page, :only => [:edit, :update, :destroy]  
  before_filter :load_parent_options, :only => [:new, :edit]
  before_filter :mark_return_point, :only => [:new, :edit]

  def index
    @pages = Page.sorted_as_tree
  end
    
  def show
    redirect_to first_live_child.url if @page.skip_to_first_child and (first_live_child = @page.children.live.asc(:position).first).present?
  end
  
  def edit
    
  end

  def update
    if @page.update_attributes(params[:page])
      return_to_last_point(:notice => 'Page has been updated')
    else
      render :action => "edit"
    end    
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      return_to_last_point(:notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  def destroy
    @page.delete
    flash[:notice] = "Page '#{@page.title}' has been deleted"    
  end

  def position
    params['page'].each_with_index do |id, i|
      page = Page.find(id);
      if page
        page.position = i
        page.save
      end
    end  
    render :nothing => true
  end  
  
  private
  
  def load_objects
    find_page
  end
  
  def find_page
    @page = params[:id] ? Page.find(params[:id]) : find_page_by_path
  end
  
  def find_page_by_path
    page = Page.find_by_path(params[:path])
    page ||= Page.new(:title => 'Welcome') unless params[:path]
    page
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
  
  def load_parent_options
    @parent_options = Page.sorted_as_tree.entries.collect do |page|
      [ ("-- " * page.depth) + page.title, page.id ]
    end
  end  
  
end