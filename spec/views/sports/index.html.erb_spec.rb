require 'spec_helper'

describe "sports/index.html.erb" do
  before(:each) do
    assign(:sports, [
      stub_model(Sport,
        :name => "Name"
      ),
      stub_model(Sport,
        :name => "Name"
      )
    ])
  end

  it "renders a list of sports" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
