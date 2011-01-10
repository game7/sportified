

Given /^the following divisions:$/ do |divisions|
  Division.create!(divisions.hashes)
end

Given /^I have no divisions$/ do
  Division.find(:all).each{|d| d.destroy}
end

Given /^a division named "([^"]*)"$/ do |name|
  Division.make!(:name => name)
end


Then /^I should have (\d+) division$/ do |count|
  Division.count.should == count.to_i
end

When /^I delete the (\d+)(?:st|nd|rd|th) divisions$/ do |pos|
  visit divisions_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following divisions:$/ do |expected_divisions_table|
  expected_divisions_table.diff!(tableish('table tr', 'td,th'))
end