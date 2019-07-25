require 'rails_helper'

RSpec.describe Admin::Events::LockerRoomsController, type: :controller do

  describe "GET #assign" do
    it "returns http success" do
      get :assign
      expect(response).to have_http_status(:success)
    end
  end

end
