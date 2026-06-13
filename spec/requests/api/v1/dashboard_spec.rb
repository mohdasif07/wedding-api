require "rails_helper"

RSpec.describe "Api::V1::Dashboard", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:event) { create(:event, user: admin) }

  before do
    create_list(:guest, 3, event: event, rsvp_status: :accepted)
    create(:guest, event: event, rsvp_status: :pending)
  end

  it "returns dashboard stats" do
    get "/api/v1/dashboard", headers: auth_headers(admin)

    expect(response).to have_http_status(:ok)
    expect(json_response["total_guests"]).to eq(4)
    expect(json_response["confirmed_guests"]).to eq(3)
    expect(json_response["pending_guests"]).to eq(1)
  end

  def auth_headers(user)
    { "Authorization" => "Bearer #{JsonWebToken.access_token_for(user)}" }
  end

  def json_response
    JSON.parse(response.body)
  end
end
