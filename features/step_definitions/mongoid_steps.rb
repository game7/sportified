

# suggested here: http://adventuresincoding.com/2010/07/how-to-configure-cucumber-and-rspec-to-work-with-mongoid

Given /^an? (.+) exists with an? (.+) of "([^"]*)"$/ do |model, field, value|
  factory_name = model.gsub(' ', '_')
  Factory factory_name, field => value
end
