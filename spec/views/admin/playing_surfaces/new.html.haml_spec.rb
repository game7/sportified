require 'rails_helper'

RSpec.describe "admin/playing_surfaces/new", :type => :view do
  before(:each) do
    assign(:admin_playing_surface, PlayingSurface.new())
  end

  it "renders new admin_playing_surface form" do
    render

    assert_select "form[action=?][method=?]", playing_surfaces_path, "post" do
    end
  end
end
