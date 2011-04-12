class PagesController < ApplicationController
  
  before_filter :load_page, :only => [:show, :edit]
  before_filter :mark_return_point, :only => [:new, :edit]

  def load_page
    @page = params[:id] ? Page.find(params[:id]) : Page.with_path(params[:path]).first
  end
  
  def index
#    @pages = Page.top_level
    @pages = Page.all.sorted_as_tree
  end

  def show

  end

  def edit
    
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    @page.position = 0
    @page.site = Site.current
    if @page.save
      return_to_last_point(:notice => 'Division was successfully created.')
    else
      render :action => "new"
    end
  end

end
