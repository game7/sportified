class GameResultObserver < Mongoid::Observer
  
  def after_create(result)
    puts 'yahoo!'
  end
  
end
