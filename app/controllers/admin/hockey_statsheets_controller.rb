class Admin::HockeyStatsheetsController < Admin::BaseLeagueController
  
  before_filter :load_statsheet

  def load_statsheet
    @statsheet = Hockey::Statsheet.find(params['id'])
  end

  def edit
    @partial = "admin/hockey_statsheets/#{params['form']}_form.html.haml"  
    @title = params['title'] 
  end

  def update
    @statsheet.update_attributes(params['hockey_statsheet'])
    flash[:notice] = "Statsheet Updated"
    render "admin/hockey_statsheets/update_#{params['form']}" if params['form']
  end


end
