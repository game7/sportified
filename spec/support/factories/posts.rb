# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    tenant nil
    title "MyString"
    summary "MyText"
    body "MyText"
    link_url "MyString"
    image "MyString"
  end
end
