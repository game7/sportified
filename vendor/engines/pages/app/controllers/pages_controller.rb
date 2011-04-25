class PagesController < ApplicationController
  
  before_filter :load_page, :only => [:show, :edit, :update, :design]
  before_filter :set_page_breadcrumbs, :only => [:show, :edit, :design]
  before_filter :load_parent_options, :only => [:new, :edit]
  before_filter :mark_return_point, :only => [:new, :edit]

  def load_page
    @page = params[:id] ? Page.find(params[:id]) : Page.with_path(params[:path]).first
  end

  def load_parent_options
    @parent_options = Page.for_site(Site.current).sorted_as_tree.entries.collect do |page|
      [ page.level.times.collect{"-"}.to_s + page.title, page.id ]
    end
  end

  def set_page_breadcrumbs
    @page.ancestors_and_self.each do |p|
      add_breadcrumb(p.title, page_friendly_path(p.path))
    end
  end
  
  def index
#    @pages = Page.top_level
    @pages = Page.all.sorted_as_tree
  end

  def show

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
    @page.position = 0
    @page.site = Site.current
    if @page.save
      return_to_last_point(:notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

end
