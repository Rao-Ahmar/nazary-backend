module Api
  module V1
    module Bike
      class BaseController < Api::V1::BaseController
        before_action :require_premium!

        private

        def require_premium!
          unless current_user&.premium?
            render json: { error: "Premium subscription required" }, status: :forbidden
          end
        end
      end
    end
  end
end
