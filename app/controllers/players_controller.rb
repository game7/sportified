class PlayersController < ApplicationController
  # GET /players
  # GET /players.xml
  def index
    @season = Season.find(params[:season_id])
    @team = @season.teams.find(params[:team_id])
    @players = @team.players

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @season = Season.find(params[:season_id])
    @team = @season.teams.find(params[:team_id])
    @player = @team.players.criteria.id(params[:id]).documents[0]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @season = Season.find(params[:season_id])
    @team = @season.teams.find(params[:team_id])
    @player = @team.players.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/1/edit
  def edit
    @season = Season.find(params[:season_id])
    @team = @season.teams.find(params[:team_id])
    @player = @team.players.build #where(:id => params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @season = Season.find(params[:season_id])
    @team = @season.teams.where(:id => params[:team_id])
    @player = @team.players.build(params[:player])

    respond_to do |format|
      if @player.save
        format.html { redirect_to([@season, @team, @player], :notice => 'Player was successfully created.') }
        format.xml  { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @season = Season.find(params[:season_id])
    @team = @season.teams.find(params[:team_id])
    @player = @team.players.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to([@season, @team, @player], :notice => 'Player was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @season = Season.find(params[:season_id])
    @team = @season.teams.find(params[:team_id])
    @player = @Steam.players.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(players_url) }
      format.xml  { head :ok }
    end
  end
end
