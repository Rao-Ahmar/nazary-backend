module Api
  module V1
    class AgenciesController < BaseController
      skip_before_action :authenticate!, only: [ :index, :show, :trips ]

      def index
        agencies = User.where(role: :planner, verified: true, deactivated: false)
        result = paginate(agencies)
        render json: result[:data], each_serializer: AgencySerializer, meta: result[:meta]
      end

      def show
        agency = User.where(role: :planner).find(params[:id])
        show_phone = should_show_phone?(agency)
        render json: agency, serializer: AgencySerializer, show_phone: show_phone
      end

      def update
        agency = User.where(role: :planner).find(params[:id])
        if agency.id != current_user.id
          return render json: { error: "Forbidden" }, status: :forbidden
        end

        if agency.update(agency_params)
          render json: agency, serializer: AgencySerializer, show_phone: true
        else
          render json: { error: agency.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      def trips
        agency = User.where(role: :planner).find(params[:id])
        trips = agency.trips.where(status: :active).order(start_date: :asc)
        result = paginate(trips)
        render json: result[:data], each_serializer: TripListSerializer, meta: result[:meta]
      end

      private

      def agency_params
        params.permit(:agency_name, :agency_tagline, :bio, :city, :phone, :years_experience,
                      :youtube_url, :instagram_url, :tiktok_url, :twitter_url, :website_url)
      end

      def should_show_phone?(agency)
        return false unless current_user
        # Show phone if traveler has an accepted trip request with this agency
        TripRequest.exists?(user_id: current_user.id, planner_id: agency.id, status: :accepted)
      end
    end
  end
end
