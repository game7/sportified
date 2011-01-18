
Given /^I have a new division named "([^"]*)"$/ do |name|
  Division.create!(:name => name)
end

When /^I go to the page for the "(.+)" division/ do |name|
  division = Division.with_name(name).first
  visit league_division_path(division)
end

When /^I go to the page for the "(.+)" season/ do |name|
  season = Season.with_name(name).first
  visit league_season_path(season)
end

Given /^the "([^"]*)" division has the following seasons:$/ do |name, table|
  division = Division.with_name(name).first
  table.hashes.each do |attributes|
    division.seasons.build(attributes).save
  end
end

Then /^I should see the following seasons:$/ do |table|
  table.hashes.each do |hash|
    Then "I should see \"#{hash[:name]}\""
  end
end





