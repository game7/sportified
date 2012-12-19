module PagesHelper
  
  def width_to_span(width)
    'span' + ( Integer(width) / 100.00 * 12 ).round.to_s
  end
  
end