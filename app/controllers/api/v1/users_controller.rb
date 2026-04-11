module Api
  module V1
    class UsersController < BaseController
      def show
        user = User.find(params[:id])
        render json: user, serializer: UserSerializer
      end

      def update
        if current_user.update(user_params)
          render json: current_user, serializer: UserSerializer
        else
          render json: { error: current_user.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      def update_avatar
        if params[:avatar].present?
          current_user.avatar.attach(params[:avatar])
          render json: current_user, serializer: UserSerializer
        else
          render json: { error: "Avatar file is required" }, status: :unprocessable_entity
        end
      end

      def update_agency_logo
        if params[:agency_logo].present?
          current_user.agency_logo.attach(params[:agency_logo])
          render json: current_user, serializer: UserSerializer
        else
          render json: { error: "Agency logo file is required" }, status: :unprocessable_entity
        end
      end

      def update_cover_photo
        if params[:cover_photo].present?
          current_user.cover_photo.attach(params[:cover_photo])
          render json: current_user, serializer: UserSerializer
        else
          render json: { error: "Cover photo file is required" }, status: :unprocessable_entity
        end
      end

      def register_device_token
        if params[:device_token].present?
          current_user.update!(device_token: params[:device_token])
          render json: { message: "Device token registered" }
        else
          render json: { error: "Device token is required" }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:name, :phone, :bio, :guild,
                       :agency_name, :agency_tagline, :years_experience, :cnic_number,
                       :youtube_url, :instagram_url, :tiktok_url, :twitter_url, :website_url,
                       :notifications_enabled)
      end
    end
  end
end
