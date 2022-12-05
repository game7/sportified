class Admin::Events::Views::ToolbarComponent < ViewComponent::Base
  def initialize(date:, skip:, title:)
    @date = date
    @skip = skip
    @title = title
  end

  def back_link
    helpers.link_to helpers.semantic_icon(:chevron, :left), params.permit!.merge({:date => @date - 1.month}), class: [:ui, :icon, :button]
  end

  def today_link
    helpers.link_to 'Today', params.permit!.merge({:date => Date.today}), class: [:ui, :button]
  end

  def next_link
    helpers.link_to helpers.semantic_icon(:chevron, :right), params.permit!.merge({:date => @date + 1.month}), class: [:ui, :icon, :button]
  end

  def new_general_event_link
    helpers.link_to 'Event', new_admin_general_event_path, class: :item
  end

  def new_league_game_link
    helpers.link_to 'Game', new_admin_league_game_path, class: :item
  end

  def new_league_practice_link
    helpers.link_to 'Practice', new_admin_league_practice_path, class: :item
  end

  def new_league_event_link
    helpers.link_to 'Event', new_admin_league_event_path, class: :item
  end

  def download_button
    helpers.link_to helpers.url_for(date: @date, format: :csv), class: [ :ui, :primary, :button] do
      helpers.semantic_icon(:download) + ' Export'
    end
  end

  def location_options
    Location.all.order(:name).collect do |location|
      [location.name, helpers.url_for(params.permit!.merge({ location_id: location.id }))]
    end.unshift(['All Locations', helpers.url_for(params.permit!.merge({ location_id: nil }))])
  end

end
