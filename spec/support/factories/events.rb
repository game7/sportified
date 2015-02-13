# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    tenant nil
    league nil
    season nil
    location nil
    type ""
    starts_on "2015-02-11 11:00:06"
    ends_on "2015-02-11 11:00:06"
    duration 1
    all_day false
    summary "MyString"
    description "MyText"
  end
end
