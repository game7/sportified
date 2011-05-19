class ContactBlocksController < ApplicationController
  
  before_filter :load_page

  def load_page
    @page = Page.find(params[:page_id])
  end

  def edit
    @block = @page.blocks.find(params[:id])    
  end

  def update
    @block = @page.blocks.find(params[:id])
    if @block.update_attributes(params[:contact_block])
      flash[:notice] = "Contact updated"          
    end
  end

end