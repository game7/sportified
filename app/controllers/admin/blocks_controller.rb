class Admin::BlocksController < Admin::AdminController
  before_filter :find_page
  before_filter :find_block, :only => [:destroy]
  
  def index
    add_breadcrumb "Pages", admin_pages_path
    add_breadcrumb "Blocks"
    add_breadcrumb @page.title_in_menu.presence || @page.title
  end
  
  def create
    @block = @page.blocks.create({}, "blocks/#{params[:block_type]}".camelize.constantize) 
    flash[:notice] = "#{params[:block_type].humanize} has been added to Page"
    redirect_to admin_page_blocks_path
  end
  
  def destroy
    @block.delete    
    flash[:notice] = "Block Deleted"
    redirect_to admin_page_blocks_path
  end
  
  private
  
  def find_page
    @page = Page.find(params[:page_id])
  end
  
  def find_block
    @block = @page.blocks.find(params[:id])   
  end
 
  
end
