module Api
  module V1
    module Bike
      class RidersController < Bike::BaseController
        def index
          profiles = BikeProfile.includes(:user).order(created_at: :desc)
          profiles = profiles.where(experience_level: params[:experience_level]) if params[:experience_level].present?
          result = paginate(profiles)
          render json: result[:data], each_serializer: BikeProfileSerializer, meta: result[:meta]
        end
      end
    end
  end
end
