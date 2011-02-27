class PagesController < ApplicationController
  
  def index
#    @pages = Page.top_level
    @pages = Page.all.sorted_as_tree
  end

  def show
    @page = params[:id] ? Page.find(params[:id]) : Page.with_path(params[:path]).first
  end

  def edit
    
  end

end
