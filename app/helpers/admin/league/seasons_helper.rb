module Admin::League::SeasonsHelper

  def teams_by_division(teams)
    divisions = {}
    teams.each do |team|
      key = team.division.name
      divisions[key] ||= { }
      divisions[key][:id] = team.division_id
      divisions[key][:name] = team.division.name
      divisions[key][:teams] ||= []
      divisions[key][:teams] << team
    end
    divisions.values
  end

end
