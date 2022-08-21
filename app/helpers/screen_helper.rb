module ScreenHelper

  def css(**styles)
    styles.transform_keys{|key| key.to_s.underscore.dasherize }
          .transform_values{|val| css_value(val) }
          .to_a
          .collect{|k, v| "#{k}: #{v}"}
          .join("; ")
  end

  def css_value(val)
    return val.collect{|val| css_value(val)}.join(" ") if val.class.name == "Array"
    return "#{val}px" if ["Integer", "Float"].include?(val.class.name)
    val
  end

  def time_range(starts_on, ends_on)
    "#{starts_on.strftime('%-I:%M %P')} - #{ends_on.strftime('%-I:%M %P')}"
  end

  def home_team_description(event)

  end

  def away_team_description(event)

  end  

end
