class League::GameResultController < ApplicationController
  
  before_filter :mark_return_point, :only => [:new, :destroy]

  def new
    @game = Game.find(params[:game_id])
    @season = @game.season
    @game.build_result

  end

  def create
    @game = Game.find(params[:game_id])
    @game.build_result(params[:game_result])
    @season = @game.season

    respond_to do |format|
      if @game.result.save
        format.html { return_to_last_point(:notice => 'Game Result has been successfully created.') }
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
      format.html { return_to_last_point(:notice => 'Game Result has been deleted.') }
      format.xml  { head :ok }
    end    
  end

end
