class Admin::PagesController < Admin::AdminController
  
  before_filter :find_page, :only => [:edit, :update, :destroy]
  #before_filter :set_page_breadcrumbs, :only => [:edit]
  before_filter :load_parent_options, :only => [:new, :edit]
  before_filter :mark_return_point, :only => [:new, :edit]
  
  def index
    @pages = Page.sorted_as_tree
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

  def find_page
    @page = Page.find(params[:id])
  end

  def load_parent_options
    @parent_options = Page.sorted_as_tree.entries.collect do |page|
      [ ("-- " * page.depth) + page.title, page.id ]
    end
  end

  #def set_page_breadcrumbs
  #  @page.ancestors_and_self.each do |p|
  #    add_breadcrumb( p.title, p.skip_to_first_child ? nil : get_page_url(p) )
  #  end
  #end

  #def set_area_navigation
  #  if @page.root?
  #    unless @page.leaf?
  #      add_area_ancestor( @page.title, get_page_url(@page), true )
  #      @page.children.each do |p|
  #        add_area_descendant( p.title, get_page_url(p) )
  #      end
  #    end
  #  else 
  #    if @page.leaf?
  #      @page.ancestors.each do |p|
  #        add_area_ancestor( p.title, get_page_url(p) )
  #        puts p.title
  #      end          
  #      @page.siblings_and_self.each do |p|
  #        add_area_descendant( p.title, get_page_url(p), @page == p)
  #      end
  #    else
  #      @page.ancestors_and_self.each do |p|
  #        add_area_ancestor( p.title, get_page_url(p), @page == p )
  #      end          
  #      @page.children.each do |d|
  #        add_area_descendant( d.title, get_page_url(d), @page == d)
  #      end
  #    end  
  #  end
  #end

  def add_area_ancestor(title, url = nil, selected = nil)
    @area_ancestors ||= []
    selected ||= url_current?(url)
    @area_ancestors << { :title => title, :url => url, :selected => selected }
  end

  def add_area_descendant(title, url = nil, selected = nil)
    @area_descendants ||= []
    selected ||= url_current?(url)
    @area_descendants << { :title => title, :url => url, :selected => selected }
  end
  
end
