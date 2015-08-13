class Hockey::Goaltender::Record < Hockey::Goaltender
  has_one :team, through: :player
  
  def add_result(result)
    STATS.each do |stat|
      self.send("#{stat}=", self.send(stat) + (result.send(stat) || 0))
    end
  end
  
  def add_result!(result)
    self.add_result result
    self.save
  end
  
  def remove_result(result)
    STATS.each do |stat|
      self.send("#{stat}=", [self.send(stat) - (result.send(stat) || 0), 0].max)
    end
  end
  
  def remove_result!(result)
    self.remove_result result
    self.save
  end
  
end
