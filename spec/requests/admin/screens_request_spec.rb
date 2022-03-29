require 'rails_helper'

RSpec.describe "Admin::Screens", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/admin/screens/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/admin/screens/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/screens/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
