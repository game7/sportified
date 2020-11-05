class Admin::Events::Views::Month::EventSummaryComponent < ViewComponent::Base
  def initialize(event:)
    @event = event
  end

  def time_range
    @event.all_day? ? 'All Day' : @event.starts_on.strftime('%-l:%M %P') + ' - ' + @event.ends_on.strftime('%-l:%M %P')
  end

  def summary
    @event.summary
  end

  def tags
    @tags ||= @event.taggings.sort{|t| t.id}.collect(&:tag)
  end

end
