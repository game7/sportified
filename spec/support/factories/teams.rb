# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team do
    name "MyString"
    short_name "MyString"
    tenant nil
    slug "MyString"
    show_in_standings false
    pool "MyString"
    seed 1
    league nil
    season nil
    club nil
  end
end
