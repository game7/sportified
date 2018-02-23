class Admin::DashboardController < Admin::AdminController

  def index
    date = Date.today
    date = Date.parse(params[:date]) if params[:date]
    @assign_form = Admin::Events::AssignForm.new(date)
  end

end
