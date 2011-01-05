
Given /^I have a new division named "([^"]*)"$/ do |name|
  Division.create!(:name => name)
end

Then /^I should have (\d+) season$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given /^the new division has a season named "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end


