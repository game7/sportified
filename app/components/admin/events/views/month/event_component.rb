class Admin::Events::Views::Month::EventComponent < ViewComponent::Base
  def initialize(event:, colors:)
    @event = event
    @colors = colors
  end

  def time
    @event.all_day? ? 'All Day' : @event.starts_on.strftime('%-l:%M %P')
  end

  def summary
    @event.summary
  end
  
  def summary_component
    Admin::Events::Views::Month::EventSummaryComponent.new event: @event
  end

  def game?
    @event.class.to_s == 'League::Game'
  end

  def league?
    @event.class.to_s.start_with? 'League'
  end

  def tag_list
    @event.taggings.collect(&:tag).join(', ')
  end

  def color_key
    @color_key ||= @event.tags[0]&.name || "no-tags"
  end

  def border_color
    @colors.border_color(color_key)
  end

  def background_color
    @colors.background_color(color_key)
  end

  def text_color
    @colors.text_color(color_key)
  end

  def show_link
    helpers.link_to 'Show', helpers.polymorphic_path([:admin, @event.module_name.to_sym, @event]), class: [:item]
  end

  def edit_link
    helpers.link_to 'Edit', helpers.edit_polymorphic_path([:admin, @event.module_name.to_sym, @event]), class: [:item]
  end

  def clone_link
    helpers.link_to 'Clone', helpers.new_polymorphic_path([:admin, @event.module_name.to_sym, @event.class], clone: @event.id), class: [:item]
  end

  def delete_link
    helpers.link_to "Delete", helpers.admin_event_path(@event), method: :delete, data: { confirm: 'Are you sure?' }, class: [:item]
  end

  def game_result_link
    helpers.link_to 'Result', helpers.edit_admin_game_result_path(@event), class: [:item]
  end

  def game_statsheet_link
    helpers.link_to 'Statsheet', helpers.edit_admin_game_statsheet_path(@event), class: [:item]
  end

  def game_print_scoresheet_link
    helpers.link_to 'Print Scoresheet', helpers.print_admin_game_statsheet_path(@event), target: :_blank, class: [:item]
  end

end
