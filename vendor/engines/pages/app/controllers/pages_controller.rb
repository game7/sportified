class PagesController < ApplicationController
  
  before_filter :load_page, :only => [:show, :edit, :update, :destroy]
  before_filter :set_page_breadcrumbs, :only => [:show, :edit]
  before_filter :load_parent_options, :only => [:new, :edit]
  before_filter :mark_return_point, :only => [:new, :edit]

  def load_page
    @page = params[:id] ? Page.find(params[:id]) : Page.with_path(params[:path]).first
  end

  def load_parent_options
    @parent_options = Page.for_site(Site.current).sorted_as_tree.entries.collect do |page|
      [ ("-- " * page.depth) + page.title, page.id ]
    end
  end

  def set_page_breadcrumbs
    @page.ancestors_and_self.each do |p|
      add_breadcrumb(p.title, p.skip_to_first_child ? nil : p.url)
    end
  end

  
  def index
#    @pages = Page.top_level
    @pages = Page.for_site(Site.current).sorted_as_tree
  end

  def show
    
    if @page.skip_to_first_child and (first_live_child = @page.children.live.asc(:position).first).present?
      redirect_to first_live_child.url
    end

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
    @page.site = Site.current
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

end
