require 'rails_helper'

RSpec.describe "Next::Admin::Planners", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/next/admin/planner/index"
      expect(response).to have_http_status(:success)
    end
  end

end
