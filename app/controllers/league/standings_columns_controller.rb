class League::StandingsColumnsController < League::BaseSeasonController
  
  def create
    @season = Season.find(params[:season_id])
    @standings_column = @season.standings_columns.build(params[:standings_column])
    @standings_column.order = @season.standings_columns.count - 1
    @team_records = @season.team_records.desc('points')
    if @standings_column.save
      flash[:notice] = "Column Added"
      @columns = @season.standings_columns
      @standings_column = StandingsColumn.new
    end
   
  end

  def push_left
    @season = Season.find(params[:season_id])
    @columns = @season.standings_columns.asc(:order).entries
    col = @season.standings_columns.find(params[:id])
    index = @columns.index(col)
    @team_records = @season.team_records.desc('points')
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
    @season = Season.find(params[:season_id])
    @columns = @season.standings_columns.asc(:order).entries
    col = @season.standings_columns.find(params[:id])
    index = @columns.index(col)
    @team_records = @season.team_records.desc('points')
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
    @season = Season.find(params[:season_id])
    @season.standings_columns.find(params[:id]).delete
    flash[:notice] = "Column has been removed"
    @columns = @season.standings_columns
    @team_records = @season.team_records.desc('points')
  end

end
