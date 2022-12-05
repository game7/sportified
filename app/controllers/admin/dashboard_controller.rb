class Admin::DashboardController < Admin::AdminController
  skip_before_action :verify_admin
  before_action :verify_admin_or_operations

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now
    # @visits_by_day = Ahoy::Visit.where('started_at >= ?', 1.week.ago)
    #                             .group_by_day(:started_at)
    #                             .count
    # @top_pages = Ahoy::Event.where('time >= ?', 1.week.ago)
    #                         .where('properties ->> \'path\' NOT LIKE \'/admin%\'')
    #                         .where('properties ->> \'path\' NOT LIKE \'/host%\'')
    #                         .where('properties ->> \'path\' NOT LIKE \'/chromecasts%\'')
    #                         .group('properties #>> \'{path}\'')
    #                         .order('count_all DESC')
    #                         .limit(10)
    #                         .count
    # @by_device = Ahoy::Visit.where('started_at >= ?', 1.week.ago)
    #                         .group(:device_type)
    #                         .count                  
    @locker_rooms = LockerRoom.order(:location_id, :name)
    # display events only for locations that have locker rooms maintained
    @events = Event.includes(location: :facilities)
                   .where(location_id: @locker_rooms.collect(&:location_id))
                   .after(@date.beginning_of_day)
                   .before(@date.end_of_day)
                   .order(:starts_on) 
  end

end
