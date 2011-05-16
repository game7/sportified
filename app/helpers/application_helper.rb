module ApplicationHelper
  

  def icon(name, alt = nil, opts = {})
    opts[:border] = 0 unless opts[:border]
    opts[:align] = "bottom" unless opts[:align]
    opts[:alt] = alt
    image_tag "../images/icons/#{name}.png", opts
  end

  def theme
    site = Site.current
    site.theme.present? ? site.theme : 'default'
  end

end
