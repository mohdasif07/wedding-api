module Api
  module V1
    class MessagesController < BaseController
      before_action -> { authorize_admin! }, only: [:create]
      before_action :set_message, only: [:show]

      def index
        scope = scoped_messages
        scope = scope.where(event_id: params[:event_id]) if params[:event_id].present?
        records = paginate(scope.recent)

        render json: MessageBlueprint.render_as_hash(records)
      end

      def show
        render json: MessageBlueprint.render_as_hash(@message, view: :detailed)
      end

      def create
        event = Event.find_by(id: params[:event_id]) if params[:event_id].present?

        result = Messages::SendService.new(
          user: current_user,
          subject: params[:subject],
          body: params[:body],
          guest_ids: params[:guest_ids],
          event: event,
          message_type: params[:message_type] || :custom,
          channel: params[:channel] || :email
        ).call

        if result[:success]
          render json: {
            message: MessageBlueprint.render_as_hash(result[:message], view: :detailed),
            sent: result[:sent],
            failed: result[:failed],
            errors: result[:errors]
          }, status: :created
        else
          render_errors(result[:errors])
        end
      end

      private

      def set_message
        @message = Message.find(params[:id])
      end
    end
  end
end
