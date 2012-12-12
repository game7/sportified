module Admin::SeasonsHelper
  
  def teams_by_division(teams)
    divisions = {}
    puts "team count: #{teams.count}"
    teams.asc(:division_name).each do |team|
      key = team.division_name
      divisions[key] ||= { }
      divisions[key][:id] = team.division_id
      divisions[key][:name] = team.division_name
      divisions[key][:teams] ||= []
      divisions[key][:teams] << team
    end
    divisions.values
  end
end