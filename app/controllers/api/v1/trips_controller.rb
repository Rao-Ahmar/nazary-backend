module Api
  module V1
    class TripsController < BaseController
      skip_before_action :authenticate!, only: [:index, :show, :featured]

      def index
        trips = Trip.active.upcoming.includes(:bookings, hero_image_attachment: :blob, host: { avatar_attachment: :blob })

        trips = trips.search_by_text(params[:q]) if params[:q].present?
        trips = trips.by_category(params[:tag]) if params[:tag].present?
        if params[:agency].present?
          trips = trips.joins(:host).where("users.agency_name ILIKE ?", "%#{params[:agency]}%")
        end
        trips = trips.where("price >= ?", params[:min_price]) if params[:min_price].present?
        trips = trips.where("price <= ?", params[:max_price]) if params[:max_price].present?
        trips = trips.by_date_range(params[:start_date_from], params[:start_date_to])
        trips = trips.by_host(params[:host_id]) if params[:host_id].present?
        trips = trips.by_trip_type(params[:trip_type]) if params[:trip_type].present?

        if params[:min_rating].present?
          rated_ids = Trip.left_joins(:reviews)
                         .group(:id)
                         .having("COALESCE(AVG(reviews.rating), 0) >= ?", params[:min_rating].to_f)
                         .pluck(:id)
          trips = trips.where(id: rated_ids)
        end

        trips = if params[:q].present? && params[:sort].blank?
                  trips  # pg_search orders by relevance rank
                else
                  case params[:sort]
                  when "price_asc" then trips.order(price: :asc)
                  when "price_desc" then trips.order(price: :desc)
                  when "newest" then trips.order(created_at: :desc)
                  when "start_date_asc" then trips.order(start_date: :asc)
                  else trips.order(start_date: :asc)
                  end
                end

        result = paginate(trips)
        render json: result[:data], each_serializer: TripListSerializer, meta: result[:meta]
      end

      def featured
        trips = Trip.featured.includes(:bookings, hero_image_attachment: :blob, host: { avatar_attachment: :blob })
        render json: trips, each_serializer: TripListSerializer
      end

      def show
        trip = Trip.includes(:host, :reviews, :bookings, :itinerary_days,
                             hero_image_attachment: :blob, gallery_attachments: :blob)
                   .find(params[:id])
        render json: trip, serializer: TripDetailSerializer
      end
    end
  end
end
