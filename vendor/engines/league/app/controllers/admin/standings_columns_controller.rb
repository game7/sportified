class Admin::StandingsColumnsController < Admin::BaseLeagueController
  
  before_filter :load_division

  def load_division
    @division = Division.for_site(Site.current).find(params[:division_id])
  end

  def get_columns(division)
    division.standings_columns.asc(:order).entries
  end
  
  def create
    @standings_column = @division.standings_columns.build(params[:standings_column])
    @standings_column.order = @division.standings_columns.count - 1
    if @standings_column.save
      flash[:notice] = "Column Added"
      @columns = get_columns(@division)
      @standings_column = StandingsColumn.new
    end
   
  end

  def push_left
    @columns = get_columns(@division)
    col = @division.standings_columns.find(params[:id])
    index = @columns.index(col)
    if index == 0
      flash[:error] = "Cannot push column left" 
    else     
      @columns.delete_at(index)
      @columns.insert(index-1, col)
      @columns.each_with_index do |c, i| 
        c.order = i
        c.save
      end
      flash[:notice] = "Column pushed left"
    end 
  end

  def push_right
    @columns = get_columns(@division)
    col = @division.standings_columns.find(params[:id])
    index = @columns.index(col)
    if index == @columns.count - 1
      flash[:error] = "Cannot push column right" 
    else 
      @columns.delete_at(index)
      @columns.insert(index+1, col)
      @columns.each_with_index do |c, i| 
        c.order = i
        c.save
      end
      flash[:notice] = "Column pushed right"  
    end
  end

  def destroy
    @division.standings_columns.find(params[:id]).delete
    flash[:notice] = "Column has been removed"
    @columns = get_columns(@division)
  end

end
