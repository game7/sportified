class Admin::Events::Views::Month::DayComponent < ViewComponent::Base
  
  def initialize(date:, selected_date:, events:, colors:)
    @date = date
    @selected_date = selected_date
    @events = events
    @colors = colors
  end

  def disabled
    @date.strftime('%m') != @selected_date.strftime('%m')
  end

  def today
    @date.to_date == Date.today
  end

  def number
    @date.strftime('%e')
  end

  def event_component(event)
    Admin::Events::Views::Month::EventComponent.new(event: event, colors: colors)
  end

  def colors
    @colors
  end

end
