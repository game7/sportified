class Api::General::EventsController < Api::BaseController

  def batch_create

    Chronic.time_class = Time.zone
    params[:event].each do |event|
      event[:starts_on] = Chronic.parse(event[:starts_on])
      set_summary event
    end

    begin
      ::General::Event.transaction do
        events = ::General::Event.create! events_params[:event]
        render json: events
      end
    rescue => ex
      render json: ex, status: 400
    end

  end

  private

    def events_params
      params.permit(
        event: [
          :starts_on,
          :duration,
          :all_day,
          :location_id,
          :away_team_custom_name,
          :home_team_custom_name,
          :summary,
          :tag_list
        ]
      )
    end

    def set_summary(event)
      event[:summary] = event[:home_team_custom_name]
      if( event[:away_team_custom_name].present? and event[:away_team_custom_name] != event[:home_team_custom_name] )
        event[:summary] << " / #{event[:away_team_custom_name]}"
      end
    end

end
