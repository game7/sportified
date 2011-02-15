module ApplicationHelper
  

  def icon(name, alt = nil, opts = {})
    opts[:border] = 0 unless opts[:border]
    opts[:align] = "bottom" unless opts[:align]
    opts[:alt] = alt
    image_tag "../images/icons/#{name}.png", opts
  end

end
