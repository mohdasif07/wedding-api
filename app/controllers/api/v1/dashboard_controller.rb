module Api
  module V1
    class DashboardController < BaseController
      def show
        stats = Dashboard::StatsService.new(current_user).call
        render json: stats
      end
    end
  end
end
