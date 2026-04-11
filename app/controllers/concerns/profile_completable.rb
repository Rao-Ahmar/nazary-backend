module ProfileCompletable
  extend ActiveSupport::Concern

  private

  def require_complete_profile!
    unless current_user&.profile_completed?
      render json: { error: "Please complete your profile first" }, status: :forbidden
    end
  end
end
