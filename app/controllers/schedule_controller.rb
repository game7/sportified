class ScheduleController < BaseLeagueController
  before_action :get_team_options, :unless => :all_divisions?
  layout :resolve_layout

  def index

    response.headers['X-FRAME-OPTIONS'] = 'ALLOWALL' if embedded?

    unless params[:tags]
      @date = params[:date] ? Date.parse(params[:date]) : Event.in_the_future.order(starts_on: :asc).pluck(:starts_on).first&.to_date || DateTime.current.beginning_of_day
      @start_date = @date.beginning_of_day
      @end_date = @date.end_of_day + 6.days
    end

    @show_tags = @division.blank?

    if params[:season_slug]
      @events = @division.events.for_season(@season).asc(:starts_on)
    else
      if params[:tags]
        match = (params[:match] == 'all') ? { match_all: true } : { any: true }
        @events = Event.in_the_future.tagged_with(params[:tags], match).order(starts_on: :asc).page params[:page]
      else
        @events = all_divisions? ? Event : @division.events
        @events = @events.includes(:location, :product)
        @events = @events.where('starts_on >= ? AND ends_on <= ?', @start_date, @end_date).order(starts_on: :asc)
        if params[:location]
          @events = @events.where(location: params[:location])
        end        
      end
    end

    @events = @events.public_only unless current_user_is_admin?
    @events = @events.includes(:location)

    @tags = Event.public_only.in_the_future.tag_counts

    @locations = Location.order(name: :asc).all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games.entries }
    end
  end

  private

  def embedded?
    params[:embed].present?
  end

  def resolve_layout
    embedded? ? 'embedded' : 'application'
  end

  def all_divisions?
    !@division
  end

  def get_team_options
    @team_options = @division.teams.for_season(@season).order(:name).collect{|t| [t.name, league_team_schedule_path(:division_slug => t.division.slug, :season_slug => t.season.slug, :team_slug => t.slug)]}
    @team_options.insert 0, ["Team Schedules", ""]
  end

end
