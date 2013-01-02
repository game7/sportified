class Blocks::BaseController < ApplicationController
  before_filter :verify_admin
  before_filter :find_page
  before_filter :find_block
  
  private
  
  def find_page
    @page = Page.find(params[:page_id])
  end
  
  def find_block
    @block = @page.blocks.find(params[:id])
  end
  
end