class Api::GamesController < ApplicationController

  def index
    horizon = params[:days] ? params[:days].to_i : 7
    render json: Game.in_the_past.after(horizon.day.ago).includes(:home_team, :away_team).order(starts_on: :desc), include: [:home_team, :away_team]
  end

  def show
    render json: Game.includes(:home_team, :away_team).find(params[:id]), include: [:home_team, :away_team]
  end

  def statify
    game = Game.find(params[:id])
    create_statsheet(game) unless game.statsheet_id
    includes = [:home_team, :away_team, statsheet: [ :skaters, :goaltenders, :goals, :penalties ]]
    render json: Game.includes(includes).find(params[:id]), include: includes
  end

  private

  def create_statsheet(game)
    ::Hockey::Statsheet.create(game: game)
  end

end
