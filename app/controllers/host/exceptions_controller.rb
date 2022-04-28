class Host::ExceptionsController < Host::HostController
  
  def index
    @exceptions = Ahoy::Event.unscoped.where_event('exception')

    if params[:exception].present?
      @exceptions = @exceptions.where_props({ exception: params[:exception] })
    end
    
    if params[:route].present?
      controller, action = params[:route].split('#')
      @exceptions = @exceptions.where_props({ params: { controller: controller, action: action } }) if params[:route].present?
    end

    if params[:hostname].present?
    @exceptions = @exceptions.where_props({ host: params[:hostname] })
    end

    if params[:date].present?
      from = DateTime.parse(params[:date])
      to = from + 1.day - 1.second
      @exceptions = @exceptions.where(time: [from..to])
    end

    @by_exception = @exceptions.group('properties #>> \'{exception}\'').order(Arel.sql('COUNT(*) DESC')).count
    @by_controller = @exceptions.group('CONCAT_WS(\'#\', properties #>> \'{params,controller}\', properties #>> \'{params,action}\')').order(Arel.sql('COUNT(*) DESC')).count
    @by_host = @exceptions.group('properties #>> \'{host}\'').order(Arel.sql('COUNT(*) DESC')).count
    @by_day = @exceptions.group_by_day(:time).count
  end

end
