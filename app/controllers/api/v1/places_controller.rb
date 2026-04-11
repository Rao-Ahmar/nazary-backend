module Api
  module V1
    class PlacesController < BaseController
      skip_before_action :authenticate!

      def index
        places = Place.all.order(created_at: :desc)
        places = places.where(region: params[:region]) if params[:region].present?
        result = paginate(places)
        render json: result[:data], each_serializer: PlaceSerializer, meta: result[:meta]
      end

      def show
        place = Place.find(params[:id])
        render json: place, serializer: PlaceSerializer
      end
    end
  end
end
