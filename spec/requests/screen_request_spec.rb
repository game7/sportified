require 'rails_helper'

RSpec.describe "Screens", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/screen/index"
      expect(response).to have_http_status(:success)
    end
  end

end
