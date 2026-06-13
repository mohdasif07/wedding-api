require "rails_helper"

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /api/v1/auth/register" do
    it "registers a new user" do
      post "/api/v1/auth/register", params: {
        first_name: "John",
        last_name: "Doe",
        email: "john@example.com",
        phone: "1234567890",
        password: "password123",
        password_confirmation: "password123"
      }

      expect(response).to have_http_status(:created)
      expect(json_response["user"]["email"]).to eq("john@example.com")
      expect(json_response["tokens"]["access_token"]).to be_present
    end
  end

  describe "POST /api/v1/auth/login" do
    let!(:user) { create(:user, email: "login@example.com", password: "password123") }

    it "returns tokens on valid credentials" do
      post "/api/v1/auth/login", params: { email: "login@example.com", password: "password123" }

      expect(response).to have_http_status(:ok)
      expect(json_response["tokens"]["access_token"]).to be_present
    end

    it "returns unauthorized on invalid credentials" do
      post "/api/v1/auth/login", params: { email: "login@example.com", password: "wrong" }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
