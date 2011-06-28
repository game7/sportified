class LayoutsController < BasePagesController
  
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

  def destroy
    layout = @page.layouts.find(params[:id])
    layout.delete
    render :nothing => true
  end
  
end
