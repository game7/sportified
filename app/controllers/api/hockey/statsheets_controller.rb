class Api::Hockey::StatsheetsController < ApplicationController

  def show
    render json: ::Hockey::Statsheet.find(params[:id])
  end

  def create
    render json: ::Hockey::Statsheet.create
  end

end
