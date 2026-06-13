require "rails_helper"

RSpec.describe "Api::V1::Events", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:headers) { auth_headers(admin) }

  describe "GET /api/v1/events" do
    before { create_list(:event, 3, user: admin) }

    it "lists events" do
      get "/api/v1/events", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json_response.length).to eq(3)
    end
  end

  describe "POST /api/v1/events" do
    it "creates an event" do
      post "/api/v1/events", params: {
        title: "Reception",
        venue: "Hotel",
        event_date: 60.days.from_now.to_date,
        status: "planned"
      }, headers: headers

      expect(response).to have_http_status(:created)
      expect(json_response["title"]).to eq("Reception")
    end
  end

  def auth_headers(user)
    token = JsonWebToken.access_token_for(user)
    { "Authorization" => "Bearer #{token}" }
  end

  def json_response
    JSON.parse(response.body)
  end
end
