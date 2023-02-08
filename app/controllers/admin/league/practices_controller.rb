class Admin::League::PracticesController < Admin::AdminController
  before_action :mark_return_point, only: %i[new edit]
  before_action :load_event, only: %i[edit update destroy]

  def new
    if params[:clone]
      clone = ::League::Practice.find(params[:clone])
      @practice = clone.dup
      load_options
    else
      load_options
      @practice = ::League::Practice.new
      @practice.program_id = @options[:programs].first.id if @options[:programs].length == 1
      @practice.location_id = @options[:locations].first.id if @options[:locations].length == 1
    end
  end

  def create
    Chronic.time_class = Time.zone
    params[:practice][:starts_on] = Chronic.parse(params[:practice][:starts_on])
    @practice = ::League::Practice.new(practice_params)
    if @practice.save
      return_to_last_point success: 'Practice was successfully created.'
    else
      puts @practice.errors.messages
      flash[:error] = 'Practice could not be created.'
      load_options
      render action: 'new'
    end
  end

  def edit
    load_options
  end

  def update
    @practice = ::League::Practice.find(params[:id])
    Chronic.time_class = Time.zone
    params[:practice][:starts_on] = Chronic.parse(params[:practice][:starts_on])
    if @practice.update(practice_params)
      return_to_last_point(notice: 'Game was successfully updated.')
    else
      flash[:error] = 'Game could not be updated.'
      load_options
      render action: 'edit'
    end
  end

  private

  def practice_params
    params.require(:practice).permit(:program_id, :season_id, :division_id, :starts_on, :duration,
                                     :location_id, :summary, :description, :show_for_all_teams,
                                     :away_team_id, :away_team_custom_name, :away_team_name,
                                     :home_team_id, :home_team_custom_name, :home_team_name,
                                     :text_before, :text_after, :show_for_all_teams,
                                     :playing_surface_id, :home_team_locker_room_id, :away_team_locker_room_id)
  end

  def load_options
    @options = {
      programs: ::League::Program.order(:name).select(:id, :name),
      divisions: ::League::Division.order(:name).select(:id, :name, :program_id).group_by { |d| d.program_id },
      seasons: ::League::Season.order(starts_on: :desc).select(:id, :name, :program_id).group_by { |s| s.program_id },
      locations: Location.order(:name).select(:id, :name),
      playing_surfaces: PlayingSurface.order(:name).select(:id, :name, :location_id).group_by { |ps| ps.location_id },
      locker_rooms: LockerRoom.order(:name).select(:id, :name, :location_id).group_by { |ps| ps.location_id },
      teams: @practice ? ::League::Team.for_division(@practice.division).for_season(@practice.season).order(:name) : []
    }
  end

  def load_event
    @practice = ::League::Practice.find(params[:id])
  end
end
