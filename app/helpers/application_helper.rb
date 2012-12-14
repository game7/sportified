module ApplicationHelper
  

  def icon(css_class, label = nil)
    content_tag(:i, nil, :class => css_class) + label
  end

  def theme
    site = Site.current
    site.present? && site.theme.present? ? site.theme : 'default'
  end
  
  def icon(name, white = false)
    "<i class=\"icon-#{name.to_s}#{' icon-white' if white}\"></i>".html_safe
  end

end
