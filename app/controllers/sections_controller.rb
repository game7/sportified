# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  pattern    :string
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_sections_on_page_id  (page_id)
#

class SectionsController < Admin::AdminController
  before_action :verify_admin
  before_action :find_page
  before_action :find_section, :only => [:destroy]

  def create
    @section = @page.sections.create({ :pattern => params[:pattern] }) 
    flash[:success] = "Section has been added to Page"
  end
  
  def destroy
    @section.destroy    
    flash[:success] = "Section Deleted"
  end
  
  def position
    params['section'].each_with_index do |id, i|
      section = @page.sections.find(id);
      if section
        section.position = i
      end
    end  
    @page.save
    render :nothing => true
  end  
  
  private
  
  def find_page
    @page = Page.find(params[:page_id])
  end
  
  def find_section
    @section = @page.sections.find(params[:id])   
  end
 
  
end
