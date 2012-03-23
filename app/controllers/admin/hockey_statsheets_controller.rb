class Admin::HockeyStatsheetsController < Admin::BaseLeagueController
  before_filter :mark_return_point, :only => [:edit]   
  before_filter :load_statsheet

  def edit
    @partial = "admin/hockey_statsheets/#{params['form']}_form.html.haml"  
    @title = params['title'] 
  end

  def update
    @statsheet.update_attributes(params['hockey_statsheet'])
    flash[:notice] = "Statsheet Updated"
    render "admin/hockey_statsheets/update_#{params['form']}" if params['form']
  end
  
  def post
    Hockey::Statsheet::Processor.post @statsheet
    flash[:success] = "Statsheet Posted"
    redirect_to edit_admin_game_statsheet_path(@statsheet.game, :return_to => return_url)
  end
  
  def unpost
    Hockey::Statsheet::Processor.unpost @statsheet
    flash[:success] = "Statsheet Unposted"
    redirect_to edit_admin_game_statsheet_path(@statsheet.game, :return_to => return_url)
  end
  
  private
  
  def load_statsheet
    @statsheet = Hockey::Statsheet.find(params['id'])
  end

end
