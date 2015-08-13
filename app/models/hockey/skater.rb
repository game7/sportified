class Hockey::Skater < ActiveRecord::Base
  include Sportified::TenantScoped
  belongs_to :player, :class_name => '::Player'
  
  STATS = %w{ games_played goals assists points 
              penalties penalty_minutes minor_penalties game_misconduct_penalties
              hat_tricks playmakers gordie_howes ejections }
              
  def self.STATS
    STATS
  end
  
  def reset
    STATS.each do |stat|
      self.send("#{stat}=", 0)
    end
  end
  
  def reset!
    self.reset
    self.save
  end
  
end
