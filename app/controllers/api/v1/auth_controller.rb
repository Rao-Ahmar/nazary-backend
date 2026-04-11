module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate!, only: [ :signup, :login, :forgot_password, :reset_password, :refresh ]

      def signup
        user = User.new(signup_params)
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
          # In production, send email with token. For now, return token in response.
          # In production, email the token. Never expose it in the API response.
          render json: { message: "Password reset instructions sent" }
        else
          # Don't reveal whether the email exists
          render json: { message: "Password reset instructions sent" }
        end
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

      private

      def signup_params
        params.permit(:name, :email, :password, :role)
      end

      def serialized_user(user)
        ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer).as_json
      end
    end
  end
end
