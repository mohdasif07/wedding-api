module Api
  module V1
    class AttendancesController < BaseController
      before_action -> { authorize_admin! }, only: [:create]
      before_action :set_event, only: [:index]

      def create
        result = Attendances::CheckInService.new(
          qr_code_token: params[:qr_code_token],
          event_id: params[:event_id]
        ).call

        if result[:success]
          render json: {
            attendance: AttendanceBlueprint.render_as_hash(result[:attendance]),
            already_checked_in: result[:already_checked_in]
          }, status: result[:already_checked_in] ? :ok : :created
        else
          render_errors(result[:errors], status: :not_found)
        end
      end

      def index
        attendances = @event.attendances.includes(:guest).order(checked_in_at: :desc)
        render json: AttendanceBlueprint.render_as_hash(attendances, view: :with_guest)
      end

      private

      def set_event
        @event = Event.find(params[:event_id])
        authorize_event_access!(@event)
      end
    end
  end
end
