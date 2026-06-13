module WeddingScoped
  extend ActiveSupport::Concern

  private

  # Admin + family share the same wedding workspace (read). Admin alone can write sensitive data.
  def wedding_team_member?
    current_user.admin? || current_user.family_member?
  end

  def scoped_events
    wedding_team_member? ? Event.all : current_user.events
  end

  def scoped_vendors
    wedding_team_member? ? Vendor.all : current_user.vendors
  end

  def scoped_expenses
    wedding_team_member? ? Expense.all : current_user.expenses
  end

  def scoped_albums
    wedding_team_member? ? Album.all : current_user.albums
  end

  def scoped_messages
    return Message.all if current_user.admin?

    if current_user.family_member?
      Message.all
    else
      Message.joins(:event).where(events: { user_id: current_user.id })
    end
  end

  def authorize_wedding_read!(record_owner_id = nil)
    return if current_user.admin?
    return if current_user.family_member?
    return if record_owner_id.nil? || record_owner_id == current_user.id

    render json: { error: "Forbidden" }, status: :forbidden
  end

  def authorize_event_access!(event)
    return if wedding_team_member?
    return if event.user_id == current_user.id

    render json: { error: "Forbidden" }, status: :forbidden
  end
end
