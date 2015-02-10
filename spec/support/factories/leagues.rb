# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :league do
    name "MyString"
    slug "MyString"
    show_standings false
    show_players false
    show_statistics false
    standings_array ""
    mongo_id "MyString"
  end
end
