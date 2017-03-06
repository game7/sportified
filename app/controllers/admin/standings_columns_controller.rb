class Admin::StandingsColumnsController < Admin::BaseLeagueController
  
  before_action :load_layout
  before_action :load_columns, :only => [:index, :push_left, :push_right]

  def load_layout
    @layout = StandingsLayout.for_site(Site.current).find(params[:standings_layout_id])
  end

  def load_columns
    @columns = @layout.columns.asc(:order).entries
  end

  def index

  end
  
  def create
    @standings_column = @layout.columns.build(params[:standings_column])
    @standings_column.order = @layout.columns.count - 1
    if @standings_column.save
      flash[:notice] = "Column Added"
      load_columns
      @standings_column = StandingsColumn.new
    end
   
  end

  def push_left
    col = @layout.columns.find(params[:id])
    index = @columns.index(col)
    if index == 0
      flash[:error] = "Cannot push column left" 
    else     
      @columns.delete_at(index)
      @columns.insert(index-1, col)
      @columns.each_with_index do |c, i| 
        c.order = i
      end
      @layout.save
      flash[:notice] = "Column pushed left"
    end 
  end

  def push_right
    col = @layout.columns.find(params[:id])
    index = @columns.index(col)
    if index == @columns.count - 1
      flash[:error] = "Cannot push column right" 
    else
      @columns.delete_at(index)
      @columns.insert(index+1, col)
      @columns.each_with_index do |c, i| 
        c.order = i
      end
      @layout.save
      flash[:notice] = "Column pushed right"  
    end
  end

  def destroy
    @layout.columns.find(params[:id]).delete
    flash[:notice] = "Column has been removed"
    load_columns
  end

end
