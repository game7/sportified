module ApplicationHelper
  

  def icon(css_class, label = nil)
    content_tag(:i, nil, :class => css_class) + label
  end

  def theme
    site = Site.current
    site.present? && site.theme.present? ? site.theme : 'default'
  end

end
