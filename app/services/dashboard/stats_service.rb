module Dashboard
  class StatsService
    def initialize(user)
      @user = user
    end

    def call
      {
        total_guests: guests.count,
        confirmed_guests: guests.where(rsvp_status: :accepted).count,
        pending_guests: guests.where(rsvp_status: :pending).count,
        total_vendors: scope_vendors.count,
        total_events: scope_events.count,
        total_expenses: scope_expenses.count,
        budget_used: scope_expenses.sum(:actual_amount).to_f,
        estimated_budget: scope_expenses.sum(:estimated_amount).to_f,
        upcoming_events: upcoming_events
      }
    end

    private

    attr_reader :user

    def scope_events
      wedding_team? ? Event.all : user.events
    end

    def scope_vendors
      wedding_team? ? Vendor.all : user.vendors
    end

    def scope_expenses
      wedding_team? ? Expense.all : user.expenses
    end

    def wedding_team?
      user.admin? || user.family_member?
    end

    def guests
      Guest.joins(:event).where(events: { id: scope_events.select(:id) })
    end

    def upcoming_events
      scope_events.upcoming.limit(5).map do |event|
        {
          id: event.id,
          title: event.title,
          venue: event.venue,
          event_date: event.event_date,
          start_time: event.start_time,
          days_until: (event.event_date - Date.current).to_i
        }
      end
    end
  end
end
