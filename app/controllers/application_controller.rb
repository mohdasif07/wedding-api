class ApplicationController < ActionController::API
  include Pagy::Backend

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

  private

  def not_found
    render json: { error: "Record not found" }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_errors(errors, status: :unprocessable_entity)
    render json: { errors: Array(errors) }, status: status
  end

  def serializer_options
    { host: request.base_url }
  end
end
