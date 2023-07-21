class Admin::Events::Views::Month::CalendarComponent < ViewComponent::Base
  def initialize(date:, events:)
    @date = date
    @events = events
    @events_by_date = @events.group_by { |event| event.starts_on.to_date }
  end

  def title
    "#{@date.strftime('%B')} #{@date.strftime('%Y')}"
  end

  def first_day
    @date.beginning_of_month.beginning_of_week
  end

  def last_day
    @date.end_of_month.end_of_week
  end

  def weeks
    (first_day..last_day).to_a.in_groups_of(7)
  end

  def day_component(day)
    date = day.to_date
    Admin::Events::Views::Month::DayComponent.new date: date,
                                                  selected_date: @date,
                                                  events: @events_by_date[date] || [],
                                                  colors: colors
  end

  def colors
    @colors ||= Colors.new
  end

  class Colors
    RGB_REGEX = /^#?([A-Fa-f\d]{2})([A-Fa-f\d]{2})([A-Fa-f\d]{2})/i

    def initialize
      @primary = {}
      @border = {}
      @background = {}
      @text = {}
    end

    def primary_color(key)
      @primary[key] || get_primary_color(key)
    end

    def border_color(key)
      @border[key] ||= get_primary_color(key)
    end

    def background_color(key)
      @background[key] ||= get_background_color(key)
    end

    def text_color(key)
      @text[key] ||= get_text_color(key)
    end

    private

    def get_primary_color(key)
      '#' + key.hash.to_s(16).slice(4, 6)
    end

    def get_border_color(key)
      '#' + key.hash.to_s(16).slice(4, 6)
    end

    def get_background_color(key)
      r, g, b = get_rgb_colors(border_color(key))
      "rgba(#{r}, #{g}, #{b}, 0.1)"
    end

    def get_text_color(_key)
      # r, g, b = get_rgb_colors(background_color(key))
      # a = 1 - (0.299 * r + 0.587 * g + 0.114 * b) / 255
      # (a < 0.5) ? '#000000' : '#ffffff'
      '#FFFFFF'
    end

    def get_rgb_colors(hex_code)
      parts = hex_code.match(RGB_REGEX)
      parts.captures.collect { |p| p.to_i(16) }
    end
  end
end
