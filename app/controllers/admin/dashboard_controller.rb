class Admin::DashboardController < Admin::AdminController

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
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
                            
  end

end
