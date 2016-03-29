require 'rails_helper'

RSpec.describe "admin/playing_surfaces/index", :type => :view do
  before(:each) do
    assign(:playing_surfaces, [
      PlayingSurface.create!(),
      PlayingSurface.create!()
    ])
  end

  it "renders a list of admin/playing_surfaces" do
    render
  end
end
