class PagesController < ApplicationController
  
  def index
    @pages = Page.all.asc(:position)
  end

  def show
    @page = Page.find(params[:id])
  end

end
