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

    #default values
    @game.result.played_on = @game.starts_on

  end

  def create
    @game = Game.find(params[:game_id])
    @game.build_result(params[:game_result])

    respond_to do |format|
      if @game.save
        format.html { redirect_to(league_season_games_path(@game.season_id), :notice => 'Game Result was successfully created.') }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end    
  end

  def destroy
    @game = Game.find(params[:game_id])
    @game.result = nil
    @game.save

    respond_to do |format|
      format.html { redirect_to(league_season_games_path(@game.season_id)) }
      format.xml  { head :ok }
    end    
  end

end
