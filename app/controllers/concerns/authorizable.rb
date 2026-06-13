module Authorizable
  extend ActiveSupport::Concern
  include WeddingScoped

  private

  def authorize_admin!
    return if current_user&.admin?

    render json: { error: "Forbidden - Admin access required" }, status: :forbidden
  end

  def authorize_event_owner!(event)
    authorize_event_access!(event)
  end
end
