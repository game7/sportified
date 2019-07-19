# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    tenant nil
    team nil
    first_name "MyString"
    last_name "MyString"
    jersey_number "MyString"
    birthdate "2015-02-10"
    email "MyString"
    slug "MyString"
  end
end
