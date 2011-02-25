class PagesController < ApplicationController
  
  def index
    @pages = Page.top_level.asc(:position)
  end

  def show
    @page = Page.find(params[:id])
  end

end
