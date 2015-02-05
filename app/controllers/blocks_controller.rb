class BlocksController < ApplicationController
  before_filter :verify_admin
  before_filter :find_page, :only => [:create]
  before_filter :find_block, :only => [:edit, :update, :destroy]

  def create
    @block = block_type.create({ section_id: params[:section_id], column: params[:column]}) do |block|
      block.page = @page
    end
    flash[:success] = "#{@block.class_name.humanize} has been added to Page"
  end
  
  def edit

  end
  
  def update
    if @block.update_attributes(params[:block])
      flash[:success] = @block.class.to_s.demodulize+" updated"          
    end    
  end
  
  def destroy
    @block.delete    
    flash[:success] = "Block Deleted"
  end
  
  def position
    params[:block].each_with_index do |id, i|
      Block.update(id, :position => i, :section_id => params[:section_id], :column => params[:column])
    end
    render :nothing => true
  end 
  
  private
  
  def block_type
    "Blocks::#{params[:block_type].classify}".constantize
  end
  
  def find_page
    @page = Page.find(params[:page_id])
  end
    
  def find_block
    @block = @page.blocks.find(params[:id])   
  end
 
  
end
