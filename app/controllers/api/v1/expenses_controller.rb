module Api
  module V1
    class ExpensesController < BaseController
      before_action :set_expense, only: %i[show update destroy]
      before_action -> { authorize_admin! }, only: %i[create update destroy]

      def index
        scope = scoped_expenses.search(params[:q])
                               .by_category(params[:category])
                               .by_payment_status(params[:payment_status])
        records = paginate(scope.order(created_at: :desc))

        render json: ExpenseBlueprint.render_as_hash(records)
      end

      def show
        render json: ExpenseBlueprint.render_as_hash(@expense)
      end

      def summary
        render json: Expenses::SummaryService.new(current_user).call
      end

      def create
        expense = current_user.expenses.build(expense_params)
        if expense.save
          render json: ExpenseBlueprint.render_as_hash(expense), status: :created
        else
          render_errors(expense.errors.full_messages)
        end
      end

      def update
        if @expense.update(expense_params)
          render json: ExpenseBlueprint.render_as_hash(@expense)
        else
          render_errors(@expense.errors.full_messages)
        end
      end

      def destroy
        @expense.destroy!
        head :no_content
      end

      private

      def set_expense
        @expense = scoped_expenses.find(params[:id])
      end

      def scoped_expenses
        super
      end

      def expense_params
        params.permit(
          :title, :category, :estimated_amount, :actual_amount,
          :payment_status, :remarks
        )
      end
    end
  end
end
