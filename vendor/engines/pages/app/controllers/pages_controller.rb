class PagesController < ApplicationController
  
  def index
    @pages = Page.top_level.asc(:position)
  end

  def show
    @page = params[:id] ? Page.find(params[:id]) : Page.with_path(params[:path]).first
  end

end
