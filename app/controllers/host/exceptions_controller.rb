class Host::ExceptionsController < Host::HostController
  
  def index
    @exceptions = Ahoy::Event.unscoped.where_event('exception')
    @by_exception = @exceptions.group('properties #>> \'{exception}\'').count
    @by_controller = @exceptions.group('CONCAT_WS(\'#\', properties #>> \'{params,controller}\', properties #>> \'{params,action}\')').count
    @by_host = @exceptions.group('properties #>> \'{host}\'').count
    @by_day = @exceptions.group_by_day(:time).count
  end

end
