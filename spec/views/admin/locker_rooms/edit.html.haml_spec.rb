require 'rails_helper'

RSpec.describe "admin/locker_rooms/edit", :type => :view do
  before(:each) do
    @admin_locker_room = assign(:admin_locker_room, LockerRoom.create!())
  end

  it "renders the edit admin_locker_room form" do
    render

    assert_select "form[action=?][method=?]", admin_locker_room_path(@admin_locker_room), "post" do
    end
  end
end
