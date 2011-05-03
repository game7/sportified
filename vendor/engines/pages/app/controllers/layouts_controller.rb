class LayoutsController < ApplicationController
  
  before_filter :load_page

  def load_page
    @page = Page.find(params[:page_id])
  end

  def index
    
  end

  def create
    if layout = @page.layouts.create( :format => params[:format] )
      render :json => layout
    end
  end

  def position
    @page.layouts.each do |layout|
      layout.position = params['layout'].index(layout.id.to_s)
    end
    @page.save
    render :nothing => true
  end
  
end
