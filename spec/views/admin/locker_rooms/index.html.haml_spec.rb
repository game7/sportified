require 'rails_helper'

RSpec.describe "admin/locker_rooms/index", :type => :view do
  before(:each) do
    assign(:locker_rooms, [
      LockerRoom.create!(),
      LockerRoom.create!()
    ])
  end

  it "renders a list of admin/locker_rooms" do
    render
  end
end
