module Authorizable
  extend ActiveSupport::Concern

  private

  def require_planner!
    render json: { error: "Forbidden" }, status: :forbidden unless current_user&.planner?
  end

  def require_traveler!
    render json: { error: "Forbidden" }, status: :forbidden unless current_user&.traveler?
  end
end
