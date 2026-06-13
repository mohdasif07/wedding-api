module Api
  module V1
    class TasksController < BaseController
      before_action -> { authorize_admin! }, only: %i[create destroy]
      before_action :set_task, only: %i[update destroy]

      def index
        scope = scoped_tasks.ordered.by_category(params[:category])
        records = paginate(scope)
        render json: TaskBlueprint.render_as_hash(records)
      end

      def create
        task = current_user.tasks.build(task_params)
        if task.save
          render json: TaskBlueprint.render_as_hash(task), status: :created
        else
          render_errors(task.errors.full_messages)
        end
      end

      def update
        if @task.update(task_params)
          render json: TaskBlueprint.render_as_hash(@task)
        else
          render_errors(@task.errors.full_messages)
        end
      end

      def destroy
        @task.destroy!
        head :no_content
      end

      private

      def scoped_tasks
        owner = User.find_by(role: :admin) || current_user
        owner.tasks
      end

      def set_task
        @task = scoped_tasks.find(params[:id])
      end

      def task_params
        params.permit(:title, :description, :category, :status, :due_date, :position)
      end
    end
  end
end
