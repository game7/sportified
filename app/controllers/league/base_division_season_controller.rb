class League::BaseDivisionSeasonController < League::BaseDivisionController
  
  def load_objects
    super
    # load specific season if slug is specified
    @season = Season.for_site(Site.current).with_slug(params[:season_slug]).first if params[:season_slug]
    @season ||= find_current_season
  end

  def find_current_season
    # load current season for division if specified
    season = @division.current_season_id ? @division.current_season : @division.seasons.desc(:starts_on).first if @division
    # otherwise just grab the most current season for the current site
    season ||= Season.desc(:starts_on).first
  end

  def set_breadcrumbs
    super
    add_breadcrumb "#{@season.name} Season" if @season 
  end

end
