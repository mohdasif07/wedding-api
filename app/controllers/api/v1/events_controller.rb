module Api
  module V1
    class EventsController < BaseController
      before_action :set_event, only: %i[show update destroy]
      before_action -> { authorize_admin! }, only: %i[create update destroy]

      def index
        scope = scoped_events.search(params[:q]).by_status(params[:status])
        records = paginate(scope.order(event_date: :asc))

        render json: EventBlueprint.render_as_hash(records, serializer_options)
      end

      def show
        authorize_event_access!(@event)
        render json: EventBlueprint.render_as_hash(@event, serializer_options.merge(view: :detailed))
      end

      def create
        event = current_user.events.build(event_params)
        if event.save
          render json: EventBlueprint.render_as_hash(event, serializer_options), status: :created
        else
          render_errors(event.errors.full_messages)
        end
      end

      def update
        if @event.update(event_params)
          render json: EventBlueprint.render_as_hash(@event, serializer_options)
        else
          render_errors(@event.errors.full_messages)
        end
      end

      def destroy
        @event.destroy!
        head :no_content
      end

      private

      def set_event
        @event = Event.find(params[:id])
      end

      def event_params
        params.permit(:title, :description, :venue, :event_date, :start_time, :end_time, :status)
      end
    end
  end
end
