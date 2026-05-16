module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token]
      reject_unauthorized_connection if token.blank?

      payload = JwtService.decode(token)
      user_id = payload&.dig(:user_id)
      reject_unauthorized_connection if user_id.blank?

      User.find_by(id: user_id) || reject_unauthorized_connection
    end
  end
end
