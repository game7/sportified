class BlocksController < ApplicationController
  before_filter :verify_admin
  before_filter :find_page
  before_filter :find_block, :only => [:edit, :update, :destroy]

  def create
    @block = @page.blocks.create({ :section_id => params[:section_id], :column => params[:column] }, "blocks/#{params[:block_type]}".camelize.constantize) 
    flash[:success] = "#{params[:block_type].humanize} has been added to Page"
    puts 'block created'
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
      block = @page.blocks.find(id);
      if block
        block.position = i
        block.section_id = params[:section_id]
        block.column = params[:column]
      end
    end  
    @page.save
    render :nothing => true
  end 
  
  private
  
  def find_page
    @page = Page.find(params[:page_id])
  end
    
  def find_block
    @block = @page.blocks.find(params[:id])   
  end
 
  
end
