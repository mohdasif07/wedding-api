module Api
  module V1
    module Auth
      class PasswordResetsController < ApplicationController
        def create
          ::Auth::PasswordResetRequestService.new(email: params[:email]).call
          render json: { message: "If the email exists, reset instructions have been sent." }
        end

        def update
          result = ::Auth::PasswordResetService.new(
            token: params[:token],
            password: params[:password],
            password_confirmation: params[:password_confirmation]
          ).call

          if result[:success]
            render json: { message: "Password has been reset successfully." }
          else
            render_errors(result[:errors])
          end
        end
      end
    end
  end
end
