require 'rails_helper'

RSpec.describe "Shedules", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/shedules/index"
      expect(response).to have_http_status(:success)
    end
  end

end
