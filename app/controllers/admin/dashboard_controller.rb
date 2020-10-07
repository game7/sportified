class Admin::DashboardController < Admin::AdminController

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now
    @visits_by_day = Ahoy::Visit.where('started_at >= ?', 1.week.ago)
                                .group_by_day(:started_at)
                                .count
    @top_pages = Ahoy::Event.where('time >= ?', 1.week.ago)
                            .where('properties ->> \'path\' NOT LIKE \'/admin%\'')
                            .where('properties ->> \'path\' NOT LIKE \'/host%\'')
                            .where('properties ->> \'path\' NOT LIKE \'/chromecasts%\'')
                            .group('properties #>> \'{path}\'')
                            .order('count_all DESC')
                            .limit(10)
                            .count
    @by_device = Ahoy::Visit.where('started_at >= ?', 1.week.ago)
                            .group(:device_type)
                            .count                            
    @events = Event.includes(location: :facilities).after(@date.beginning_of_day).before(@date.end_of_day).order(:starts_on) 
    @locker_rooms = LockerRoom.order(:location_id, :name)                       
  end

end
