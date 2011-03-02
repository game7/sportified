
Given /^the "([^"]*)" season has the following teams$/ do |season_name, table|
  season = Season.with_name(season_name).first
  table.hashes.each do |attributes|
    season.teams.build(attributes).save
  end
end

Given /^the "([^"]*)" is the current season for the "([^"]*)" division$/ do |season_name, division_name|
  division = Division.with_name(division_name).first
  season = division.seasons.with_name(season_name).first
  division.current_season = season
  division.save
end

Then /^I should see the following teams:$/ do |table|
  table.hashes.each do |hash|
    Then "I should see \"#{hash[:name]}\""
  end
end

When /^I go to the standings page for the "(.+)" division/ do |name|
  division = Division.with_name(name).first
  visit league_standings_path(division.slug)
end

