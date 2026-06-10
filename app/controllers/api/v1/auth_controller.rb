module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate!, only: [ :signup, :login, :forgot_password, :reset_password, :refresh, :google ]

      def signup
        user = User.new(signup_params.except(:referral_code))
        if params[:referral_code].present?
          referrer = User.find_by(referral_code: params[:referral_code])
          user.referred_by = referrer if referrer
        end
        if user.save
          token = JwtService.encode(user.id)
          refresh_token = user.generate_refresh_token!
          render json: {
            user: serialized_user(user),
            token: token,
            refresh_token: refresh_token
          }, status: :created
        else
          render json: { error: user.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email]&.downcase)
        if user&.authenticate(params[:password])
          if user.deactivated?
            return render json: { error: "Account has been deactivated" }, status: :forbidden
          end
          token = JwtService.encode(user.id)
          refresh_token = user.generate_refresh_token!
          render json: {
            user: serialized_user(user),
            token: token,
            refresh_token: refresh_token
          }
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      def logout
        current_user&.update(refresh_token: nil)
        head :no_content
      end

      def me
        render json: current_user, serializer: UserSerializer
      end

      def forgot_password
        user = User.find_by(email: params[:email]&.downcase)
        if user
          token = user.generate_password_reset_token!
          PasswordResetMailer.reset_link(user: user, token: token).deliver_later
        end
        # Don't reveal whether the email exists
        render json: { message: "Password reset instructions sent" }
      end

      def reset_password
        user = User.find_by(password_reset_token: params[:token])
        if user.nil? || !user.password_reset_valid?
          return render json: { error: "Invalid or expired reset token" }, status: :unprocessable_entity
        end

        if params[:password].blank?
          return render json: { error: "Password is required" }, status: :unprocessable_entity
        end

        user.password = params[:password]
        user.save!
        user.clear_password_reset!
        render json: { message: "Password has been reset successfully" }
      end

      def refresh
        user = User.find_by(refresh_token: params[:refresh_token])
        if user.nil?
          return render json: { error: "Invalid refresh token" }, status: :unauthorized
        end

        token = JwtService.encode(user.id)
        new_refresh_token = user.generate_refresh_token!
        render json: {
          token: token,
          refresh_token: new_refresh_token
        }
      end

      def google
        id_token = params[:id_token]
        return render json: { error: "id_token is required" }, status: :bad_request if id_token.blank?

        # Validate token with Google
        response = Net::HTTP.get_response(URI("https://oauth2.googleapis.com/tokeninfo?id_token=#{id_token}"))
        unless response.is_a?(Net::HTTPSuccess)
          return render json: { error: "Invalid Google token" }, status: :unauthorized
        end

        google_info = JSON.parse(response.body)
        google_uid = google_info["sub"]
        email = google_info["email"]&.downcase
        name = google_info["name"] || email&.split("@")&.first

        return render json: { error: "Invalid Google token" }, status: :unauthorized if google_uid.blank? || email.blank?

        user = User.find_by(google_uid: google_uid) || User.find_by(email: email)

        if user.nil?
          selected_role = %w[traveler planner].include?(params[:role]) ? params[:role] : "traveler"
          user = User.new(name: name, email: email, google_uid: google_uid, role: selected_role,
                          password: SecureRandom.hex(32))
          unless user.save
            return render json: { error: user.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        elsif user.google_uid.blank?
          user.update!(google_uid: google_uid)
        end

        if user.deactivated?
          return render json: { error: "Account has been deactivated" }, status: :forbidden
        end

        token = JwtService.encode(user.id)
        refresh_token = user.generate_refresh_token!
        render json: {
          user: serialized_user(user),
          token: token,
          refresh_token: refresh_token
        }
      end

      private

      def signup_params
        params.permit(:name, :email, :password, :role, :referral_code)
      end

      def serialized_user(user)
        ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer).as_json
      end
    end
  end
end
