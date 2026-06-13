module Api
  module V1
    class ProfilesController < BaseController
      def show
        render json: UserBlueprint.render_as_hash(current_user)
      end

      def update
        if current_user.update(profile_params)
          render json: UserBlueprint.render_as_hash(current_user)
        else
          render_errors(current_user.errors.full_messages)
        end
      end

      private

      def profile_params
        params.permit(:first_name, :last_name, :phone, :password, :password_confirmation)
      end
    end
  end
end
