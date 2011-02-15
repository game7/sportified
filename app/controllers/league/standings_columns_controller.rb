class League::StandingsColumnsController < League::BaseDivisionController
  
  def create
    @division = Division.find(params[:division_id])
    @standings_column = @division.standings_columns.build(params[:standings_column])
    @standings_column.order = @division.standings_columns.count - 1
    @team_records = @division.team_records.for_season(@division.current_season_id).desc('points')
    if @standings_column.save
      flash[:notice] = "Column Added"
      @columns = @division.standings_columns.asc(:order).entries
      @standings_column = StandingsColumn.new
    end
   
  end

  def push_left
    @division = Division.find(params[:division_id])
    @columns = @division.standings_columns.asc(:order).entries
    col = @division.standings_columns.find(params[:id])
    index = @columns.index(col)
    @team_records = @division.team_records.for_season(@division.current_season_id).desc('points')
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
    @division = Division.find(params[:division_id])
    @columns = @division.standings_columns.asc(:order).entries
    col = @division.standings_columns.find(params[:id])
    index = @columns.index(col)
    @team_records = @division.team_records.for_season(@division.current_season_id).desc('points')
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
    @division = Division.find(params[:division_id])
    @division.standings_columns.find(params[:id]).delete
    flash[:notice] = "Column has been removed"
    @columns = @division.standings_columns.asc(:order).entries
    @team_records = @division.team_records.for_season(@division.current_season_id).desc('points')
  end

end
