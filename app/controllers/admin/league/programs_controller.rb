class Admin::League::ProgramsController < ApplicationController
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_breadcrumbs
  before_filter :find_league, :only => [:edit, :update, :destroy]

  def show
    @league = ::League::Program.find(params[:id])
    @divisions = ::League::Division.order(:name)
    @seasons = ::League::Season.order(starts_on: :desc)

    @events = ::Event.where(program: @league).after(Date.current - 7.days).before(Date.current + 7.days).order(:starts_on)
  end

  def new
    @league = ::League::Program.new
  end

  def create
    @league = ::League::Program.new(league_params)
    if @league.save
      return_to_last_point :success => 'League was successfully created.'
    else
      flash[:error] = 'League could not be created'
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @league.update_attributes(league_params)
      return_to_last_point :success => 'League was successfully updated.'
    else
      flash[:error] = 'League could not be updated.'
      render :action => "edit"
    end
  end

  def destroy
    @league.destroy
    return_to_last_point :success => 'League has been deleted.'
  end

  private

  def league_params
    params.required(:league_program).permit(:name, :description)
  end

  def add_breadcrumbs
    add_breadcrumb 'Programs', admin_programs_path
  end

  def find_league
    @league = ::League::Program.find(params[:id])
  end
end
