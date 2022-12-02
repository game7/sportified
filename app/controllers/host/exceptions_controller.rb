class Host::ExceptionsController < Host::BaseController
  def index
    inertia props: {
      by_exception: group_by_exception(exceptions),
      by_controller: group_by_controller(exceptions),
      by_host: group_by_host(exceptions),
      by_day: group_by_day(exceptions),
      exceptions: exceptions.count <= 100 ? exceptions.take(100) : nil
    }
  end

  private

  def exceptions
    @exceptions ||= Ahoy::Event.unscoped.exceptions
                               .on_date(params[:date])
                               .where_host(params[:hostname])
                               .where_exception(params[:exception])
                               .where_route(params[:route])
  end

  def group_by_exception(exceptions)
    exceptions.group('properties #>> \'{exception}\'')
              .order(Arel.sql('COUNT(*) DESC'))
              .count
  end

  def group_by_controller(exceptions)
    exceptions.group('CONCAT_WS(\'#\', properties #>> \'{params,controller}\', properties #>> \'{params,action}\')')
              .order(Arel.sql('COUNT(*) DESC'))
              .count
  end

  def group_by_host(exceptions)
    exceptions.group('properties #>> \'{host}\'')
              .order(Arel.sql('COUNT(*) DESC'))\
              .count
  end

  def group_by_day(exceptions)
    exceptions.group_by_day(:time)
              .count
  end
end
