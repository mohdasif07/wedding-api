class ExpenseBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :category, :estimated_amount, :actual_amount,
         :payment_status, :remarks, :created_at
end
