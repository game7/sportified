# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    tenant nil
    name "MyString"
    short_name "MyString"
  end
end
