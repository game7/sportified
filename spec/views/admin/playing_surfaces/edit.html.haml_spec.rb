require 'rails_helper'

RSpec.describe "admin/playing_surfaces/edit", :type => :view do
  before(:each) do
    @admin_playing_surface = assign(:admin_playing_surface, PlayingSurface.create!())
  end

  it "renders the edit admin_playing_surface form" do
    render

    assert_select "form[action=?][method=?]", admin_playing_surface_path(@admin_playing_surface), "post" do
    end
  end
end
