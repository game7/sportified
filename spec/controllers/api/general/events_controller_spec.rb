require 'rails_helper'

RSpec.describe Api::General::EventsController, type: :controller do

  describe "GET #batch_create" do
    it "returns http success" do
      get :batch_create
      expect(response).to have_http_status(:success)
    end
  end

end
