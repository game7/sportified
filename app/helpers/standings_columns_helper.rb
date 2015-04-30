module StandingsColumnsHelper
  
  def is_float?(field)
    field && field.is_a?(Float)
  end

end
