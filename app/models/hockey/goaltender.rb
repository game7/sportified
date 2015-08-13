class Hockey::Goaltender < ActiveRecord::Base
  include Sportified::TenantScoped  
  belongs_to :player, class_name: '::Player'

  STATS = %w{ games_played minutes_played
              shots_against goals_against 
              shootout_attempts shootout_goals shootout_save_percentage
              regulation_wins regulation_losses
              overtime_wins overtime_losses
              shootout_wins shootout_losses
              total_wins total_losses }
              
  def goals_against=(value)
    write_attribute(:goals_against, value)
    calculate_saves
    calculate_save_percentage
    calculate_goals_against_average    
  end
  
  def shots_against=(value)
    write_attribute(:shots_against, value)
    calculate_saves
    calculate_save_percentage    
  end
  
  def minutes_played=(value)
    write_attribute(:minutes_played, value)
    calculate_goals_against_average
  end
              
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
  
  private
  
  def calculate_saves
    self.saves = self.shots_against - self.goals_against
  end
  
  def calculate_save_percentage
    self.save_percentage = self.shots_against.nonzero? ? self.saves.to_f / self.shots_against.nonzero? : 0
  end
  
  def calculate_goals_against_average
    self.goals_against_average = (self.goals_against / (self.minutes_played / 45.0) )
  end
    
end
