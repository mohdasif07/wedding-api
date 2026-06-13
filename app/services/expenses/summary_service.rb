module Expenses
  class SummaryService
    def initialize(user)
      @user = user
    end

    def call
      expenses = wedding_team? ? Expense.all : user.expenses
      {
        estimated_budget: expenses.sum(:estimated_amount).to_f,
        actual_spend: expenses.sum(:actual_amount).to_f,
        remaining_budget: expenses.sum(:estimated_amount).to_f - expenses.sum(:actual_amount).to_f,
        by_category: category_breakdown(expenses),
        monthly: monthly_breakdown(expenses)
      }
    end

    private

    attr_reader :user

    def wedding_team?
      user.admin? || user.family_member?
    end

    def category_breakdown(expenses)
      Expense.categories.keys.index_with do |category|
        expenses.where(category: category).sum(:actual_amount).to_f
      end
    end

    def monthly_breakdown(expenses)
      expenses
        .where("created_at >= ?", 12.months.ago)
        .group(Arel.sql("DATE_TRUNC('month', created_at)"))
        .sum(:actual_amount)
        .transform_keys { |k| k.strftime("%Y-%m") }
        .transform_values(&:to_f)
    end
  end
end
