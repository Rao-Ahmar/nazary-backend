module Api
  module V1
    module Bike
      class ProfilesController < Bike::BaseController
        def show
          profile = current_user.bike_profile
          if profile
            render json: profile, serializer: BikeProfileSerializer
          else
            render json: { error: "Bike profile not found" }, status: :not_found
          end
        end

        def create
          profile = current_user.build_bike_profile(bike_profile_params)

          if profile.save
            render json: profile, serializer: BikeProfileSerializer, status: :created
          else
            render json: { error: profile.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        def update
          profile = current_user.bike_profile
          return render json: { error: "Bike profile not found" }, status: :not_found unless profile

          if profile.update(bike_profile_params)
            render json: profile, serializer: BikeProfileSerializer
          else
            render json: { error: profile.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        private

        def bike_profile_params
          params.permit(:bike_model, :bike_cc, :experience_level, :bio)
        end
      end
    end
  end
end
