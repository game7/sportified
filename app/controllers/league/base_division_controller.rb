class League::BaseDivisionController < League::BaseLeagueController
  
  def load_objects
    super
    @division = Division.with_slug(params[:division_slug]).first if params[:division_slug]
  end

  def set_breadcrumbs
    super
    add_breadcrumb( "#{@division.name} Division", league_division_path(@division.slug) ) if @division
  end

  def set_area_navigation
    if @division        
      add_area_menu_item('Home', league_division_path(@division.slug))
      add_area_menu_item('Schedule', league_schedule_path(@division.slug))
      add_area_menu_item('Scoreboard', league_scoreboard_path(@division.slug))
      add_area_menu_item('Standings', league_standings_path(@division.slug))
      # TODO: add_area_menu_item('Statistics')
      add_area_menu_item('Teams', league_teams_path(@division.slug))
      # TODO: add_area_menu_item('Players')
    else
      add_area_menu_item('Home', league_path)
      add_area_menu_item('Schedule', league_schedule_path)
      add_area_menu_item('Scoreboard', league_scoreboard_path)
      #add_area_descendant('Standings', league_standings_path)
      # TODO: add_area_menu_item('Statistics')
      add_area_menu_item('Teams', league_teams_path)      
    end

  end

end
