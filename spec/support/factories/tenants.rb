# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tenant do
    host "www.example.com"
    description "Same Old Test Website"
    analytics_id "abcdefg-123456"
  end
end
