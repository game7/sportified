class BasePagesController < ApplicationController
  
  authorize_resource :class => false, :except => [:show]  

  before_filter :load_page
  def load_page
    @page = Page.find(params[:page_id])
  end

end
