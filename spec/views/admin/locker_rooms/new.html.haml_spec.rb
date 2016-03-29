require 'rails_helper'

RSpec.describe "admin/locker_rooms/new", :type => :view do
  before(:each) do
    assign(:admin_locker_room, LockerRoom.new())
  end

  it "renders new admin_locker_room form" do
    render

    assert_select "form[action=?][method=?]", locker_rooms_path, "post" do
    end
  end
end
