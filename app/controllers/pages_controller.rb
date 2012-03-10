class PagesController < ApplicationController
  before_filter :find_page
  
  def show  
    redirect_to first_live_child.url if @page.skip_to_first_child and (first_live_child = @page.children.live.asc(:position).first).present?
  end
  
  private
  
  def find_page
    @page = Page.with_path(params[:path]).first    
  end
end