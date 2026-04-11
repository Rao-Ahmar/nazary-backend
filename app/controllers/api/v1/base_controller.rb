module Api
  module V1
    class BaseController < ActionController::API
      include Authenticatable
      include Authorizable
      include Paginatable

      before_action :authenticate!

      rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "Not found" }, status: :not_found
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end
