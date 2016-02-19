class Api::GamesController < ApplicationController
  include ::ActionController::Serialization

  def index

    horizon = params[:days] ? params[:days].to_i : 7
    render json: Game.in_the_past.after(horizon.day.ago).order(starts_on: :desc)

  end

  def show
    render json: Game.find(params[:id])
  end

end
