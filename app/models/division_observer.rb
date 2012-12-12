class DivisionObserver < Mongoid::Observer
  
  def after_save(division)
    division.teams.each do |team|
      team.set_division_name division
      team.save
    end
  end
  
end
