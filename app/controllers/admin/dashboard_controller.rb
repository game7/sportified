class Admin::DashboardController < Admin::AdminController

  def index
    date = params[:date] ? Date.parse(params[:date]) : Date.today
    @assign_form = Admin::Events::AssignForm.new(date)
  end

end
