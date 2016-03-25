FactoryGirl.define do
  factory :registrar_session, class: 'Registrar::Session' do
    registrable nil
    title "MyString"
    description "MyText"
    registrations_allowed 1
    registrations_available 1
  end
end
