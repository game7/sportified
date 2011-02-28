class PagesController < ApplicationController
  
  before_filter :load_page, :only => [:show, :edit]

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

end
