FactoryGirl.define do
  factory :registrar_registration_type, class: 'Registrar::RegistrationType' do
    session nil
    title "MyString"
    description "MyText"
    price "9.99"
    quantity_allowed 1
    quantity_available 1
  end
end
