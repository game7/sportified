# == Schema Information
#
# Table name: league_seasons
#
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  starts_on  :date
#  tenant_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  program_id :integer
#
# Indexes
#
#  index_league_seasons_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_...  (program_id => programs.id)
#  fk_rails_...  (program_id => programs.id)
#

class League::SeasonsController < BaseLeagueController

  before_action :mark_return_point, :only => [:new, :edit, :destroy]    
  before_action :load_for_season, :only => [:show, :edit]

  def load_for_season
    
    if params[:id]
      @season = Season.for_site(Site.current).find(params[:id])
      @division = @season.division
    else
      @division = Division.for_site(Site.current).with_slug(params[:division_slug]).first
      @season = @division.seasons.with_slug(params[:season_slug]).first
    end

    add_breadcrumb @division.name, division_friendly_path(@division.slug)
    add_breadcrumb @season.name

    load_area_navigation @division, @season

  end

 
  # GET /seasons
  # GET /seasons.xml
  def index

    @seasons = Season.for_site(Site.current)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @seasons }
    end
  end

  # GET /seasons/1
  # GET /seasons/1.xml
  def show

    @teams = @season.teams

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/new
  # GET /seasons/new.xml
  def new

    @season = Season.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/1/edit
  def edit

  end

  # POST /seasons
  # POST /seasons.xml
  def create
    @season = Season.new(params[:season])

    respond_to do |format|
      if @season.save
        format.html { return_to_last_point(:notice => 'Season was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /seasons/1
  # PUT /seasons/1.xml
  def update
    @season = Season.find(params[:id])

    respond_to do |format|
      if @season.update_attributes(params[:season])
        format.html { return_to_last_point(:notice => 'Season was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.xml
  def destroy
    @season = Season.find(params[:id])
    @season.destroy

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Season has been deleted.') }
      format.xml  { head :ok }
    end
  end
end
