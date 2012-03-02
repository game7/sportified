class BaseDivisionController < BaseLeagueController
  
  def load_objects
    super
    @division = Division.with_slug(params[:division_slug]).first if params[:division_slug]
  end

  def set_breadcrumbs
    super
    add_breadcrumb( "#{@division.name} Division", division_path(@division.slug) ) if @division
  end

  def set_area_navigation
    if @division        
      add_area_menu_item('Home', division_path(@division.slug))
      add_area_menu_item('Schedule', schedule_path(@division.slug))
      add_area_menu_item('Scoreboard', scoreboard_path(@division.slug))
      add_area_menu_item('Standings', standings_path(@division.slug))
      # TODO: add_area_menu_item('Statistics')
      add_area_menu_item('Teams', teams_path(@division.slug))
      # TODO: add_area_menu_item('Players')
    else
      #add_area_menu_item('Home', path)
      #add_area_menu_item('Schedule', schedule_path)
      #add_area_menu_item('Scoreboard', scoreboard_path)
      ##add_area_descendant('Standings', standings_path)
      ## TODO: add_area_menu_item('Statistics')
      #add_area_menu_item('Teams', teams_path)      
    end

  end

end
