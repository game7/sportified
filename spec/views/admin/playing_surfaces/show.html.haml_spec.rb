require 'rails_helper'

RSpec.describe "admin/playing_surfaces/show", :type => :view do
  before(:each) do
    @admin_playing_surface = assign(:admin_playing_surface, PlayingSurface.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
