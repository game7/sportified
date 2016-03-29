require 'rails_helper'

RSpec.describe "admin/locker_rooms/show", :type => :view do
  before(:each) do
    @admin_locker_room = assign(:admin_locker_room, LockerRoom.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
