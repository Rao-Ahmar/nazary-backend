module Api
  module V1
    class PlacesController < BaseController
      skip_before_action :authenticate!

      def index
        places = Place.includes(cover_image_attachment: :blob).order(created_at: :desc)
        places = places.where(region: params[:region]) if params[:region].present?
        result = paginate(places)
        expires_in 10.minutes, public: true
        render json: result[:data], each_serializer: PlaceSerializer, meta: result[:meta]
      end

      def show
        place = Place.find(params[:id])
        expires_in 10.minutes, public: true
        render json: place, serializer: PlaceSerializer
      end
    end
  end
end
