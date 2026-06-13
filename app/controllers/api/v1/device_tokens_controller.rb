module Api
  module V1
    class DeviceTokensController < BaseController
      def create
        token = current_user.device_tokens.find_or_initialize_by(token: params[:token])
        token.platform = params[:platform]

        if token.save
          render json: { id: token.id, token: token.token, platform: token.platform }, status: :created
        else
          render_errors(token.errors.full_messages)
        end
      end

      def destroy
        token = current_user.device_tokens.find_by!(token: params[:token])
        token.destroy!
        head :no_content
      end
    end
  end
end
