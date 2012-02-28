module League::StandingsColumnsHelper
  
  def is_float?(field)
    field && field.options[:type].to_s == "Float"
  end

end
