module Api
  module V1
    class InvitationsController < BaseController
      before_action -> { authorize_admin! }
      before_action :set_event
      before_action :set_guest, only: [:create]

      def create
        result = Invitations::SendService.new(
          guest: @guest,
          user: current_user,
          channel: params[:channel] || :email
        ).call

        if result[:success]
          render json: {
            message: "Invitation sent to #{@guest.full_name}",
            guest: GuestBlueprint.render_as_hash(@guest.reload),
            delivery: MessageRecipientBlueprint.render_as_hash(result[:recipient])
          }, status: :created
        else
          render_errors(result[:errors])
        end
      end

      def bulk_create
        result = Invitations::BulkSendService.new(
          event: @event,
          user: current_user,
          guest_ids: params[:guest_ids],
          channel: params[:channel] || :email
        ).call

        if result[:success]
          render json: {
            message: "Invitations processed",
            sent: result[:results][:sent],
            failed: result[:results][:failed],
            errors: result[:results][:errors]
          }
        else
          render_errors(result[:errors])
        end
      end

      private

      def set_event
        @event = Event.find(params[:event_id])
      end

      def set_guest
        @guest = @event.guests.find(params[:guest_id] || params[:id])
      end
    end
  end
end
