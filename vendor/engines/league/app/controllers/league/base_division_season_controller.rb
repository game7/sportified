class League::BaseDivisionSeasonController < League::BaseDivisionController
  
  def load_objects
    super
    @season = Season.with_slug(params[:division_slug]).first if params[:season_slug]
    @season ||= @division.current_season_id ? @division.current_season : @division.seasons.desc(:starts_on).first if @division
  end

  def set_breadcrumbs
    super
    add_new_breadcrumb "#{@season.name} Season" if @season 
  end

end
