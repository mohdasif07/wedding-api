module Api
  module V1
    module Auth
      class RegistrationsController < ApplicationController
        def create
          result = ::Auth::RegisterService.new(registration_params).call

          if result[:success]
            render json: {
              user: UserBlueprint.render_as_hash(result[:user]),
              tokens: result[:tokens]
            }, status: :created
          else
            render_errors(result[:errors])
          end
        end

        private

        def registration_params
          params.permit(:first_name, :last_name, :email, :phone, :password, :password_confirmation)
        end
      end
    end
  end
end
