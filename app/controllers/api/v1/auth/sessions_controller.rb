module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        def create
          result = ::Auth::LoginService.new(
            email: params[:email],
            password: params[:password]
          ).call

          if result[:success]
            render json: {
              user: UserBlueprint.render_as_hash(result[:user]),
              tokens: result[:tokens]
            }
          else
            render_errors(result[:errors], status: :unauthorized)
          end
        end

        def destroy
          authenticate_optional_user!
          return render_unauthorized unless current_user

          ::Auth::LogoutService.new(
            user: current_user,
            refresh_token: params[:refresh_token]
          ).call

          head :no_content
        end

        def refresh
          result = ::Auth::RefreshTokenService.new(refresh_token: params[:refresh_token]).call

          if result[:success]
            render json: {
              user: UserBlueprint.render_as_hash(result[:user]),
              tokens: result[:tokens]
            }
          else
            render_errors(result[:errors], status: :unauthorized)
          end
        end

        private

        def authenticate_optional_user!
          token = request.headers["Authorization"]&.split(" ")&.last
          return unless token

          payload = JsonWebToken.decode(token)
          @current_user = User.find_by(id: payload[:user_id]) if payload&.dig(:type) == "access"
        end

        def current_user
          @current_user
        end

        def render_unauthorized
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end
    end
  end
end
