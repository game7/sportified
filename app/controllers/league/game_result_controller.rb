class League::GameResultController < ApplicationController
  
  def show
  end

  def index
  end

  def edit
  end

  def new
    @game = Game.find(params[:game_id])
    @season = @game.season
    @game.result = GameResult.new

  end

  def create
    @game = Game.find(params[:game_id])
    @game.build_result(params[:game_result])
    @season = @game.season

    respond_to do |format|
      if @game.result.save
        format.html { redirect_to( league_season_scoreboard_friendly_path(@season.division.slug, @season.slug), :notice => 'Game Result was successfully created.') }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end    
  end

  def destroy
    @game = Game.find(params[:game_id])
    @game.result.destroy
    @game.save
    @season = @game.season

    respond_to do |format|
      format.html { redirect_to( league_season_scoreboard_friendly_path(@season.division.slug, @season.slug) ) }
      format.xml  { head :ok }
    end    
  end

end
