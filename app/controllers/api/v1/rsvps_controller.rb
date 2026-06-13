module Api
  module V1
    class RsvpsController < BaseController
      before_action :set_event
      before_action :set_guest, only: %i[show update]

      def index
        rsvps = @event.rsvps.includes(:guest)
        render json: RsvpBlueprint.render_as_hash(rsvps)
      end

      def show
        rsvp = @guest.rsvps.find_by!(event: @event)
        render json: RsvpBlueprint.render_as_hash(rsvp)
      end

      def update
        rsvp = @guest.rsvps.find_or_initialize_by(event: @event)
        rsvp.status = params[:status]

        if rsvp.save
          render json: RsvpBlueprint.render_as_hash(rsvp)
        else
          render_errors(rsvp.errors.full_messages)
        end
      end

      private

      def set_event
        @event = Event.find(params[:event_id])
        authorize_event_access!(@event)
      end

      def set_guest
        @guest = @event.guests.find(params[:guest_id] || params[:id])
      end
    end
  end
end
