module Api
  module V1
    class GuestsController < BaseController
      before_action :set_event
      before_action :set_guest, only: %i[show update destroy]
      before_action -> { authorize_admin! }, only: %i[create update destroy]

      def index
        scope = @event.guests.search(params[:q]).by_rsvp(params[:rsvp_status]).by_side(params[:side])
        records = paginate(scope.order(:last_name, :first_name))

        render json: GuestBlueprint.render_as_hash(records)
      end

      def show
        render json: GuestBlueprint.render_as_hash(@guest)
      end

      def create
        guest = @event.guests.build(guest_params)
        if guest.save
          render json: GuestBlueprint.render_as_hash(guest), status: :created
        else
          render_errors(guest.errors.full_messages)
        end
      end

      def update
        if @guest.update(guest_params)
          render json: GuestBlueprint.render_as_hash(@guest)
        else
          render_errors(@guest.errors.full_messages)
        end
      end

      def destroy
        @guest.destroy!
        head :no_content
      end

      private

      def set_event
        @event = Event.find(params[:event_id])
        authorize_event_access!(@event)
      end

      def set_guest
        @guest = @event.guests.find(params[:id])
      end

      def guest_params
        params.permit(
          :first_name, :last_name, :phone, :email, :family_name,
          :side, :rsvp_status, :address
        )
      end
    end
  end
end
