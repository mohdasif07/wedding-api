class TaskBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :description, :category, :status, :due_date, :position, :created_at, :updated_at
end
