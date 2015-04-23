FactoryGirl.define do
  factory :hockey_event, :class => 'Hockey::Event' do
    statsheet nil
period 1
minute 1
second 1
player "MyString"
  end

end
