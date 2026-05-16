module Api
  module V1
    class AgenciesController < BaseController
      skip_before_action :authenticate!, only: [ :index, :show, :trips, :check_name, :explore ]

      def index
        agencies = User.where(role: :planner, deactivated: false)
        if params[:q].present?
          q = "%#{params[:q]}%"
          agencies = agencies.where("agency_name ILIKE :q OR name ILIKE :q OR city ILIKE :q", q: q)
        end
        result = paginate(agencies)
        render json: result[:data], each_serializer: AgencySerializer, meta: result[:meta]
      end

      def show
        agency = User.where(role: :planner).find(params[:id])
        render json: agency, serializer: AgencySerializer
      end

      def update
        agency = User.where(role: :planner).find(params[:id])
        if agency.id != current_user.id
          return render json: { error: "Forbidden" }, status: :forbidden
        end

        if agency.update(agency_params)
          if agency.saved_change_to_instagram_url? || agency.saved_change_to_tiktok_url?
            VerifySocialAccountsJob.perform_later(agency.id)
          end
          render json: agency, serializer: AgencySerializer
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

      def check_name
        name = params[:name].to_s.strip.downcase
        if name.blank?
          return render json: { error: "Name parameter is required" }, status: :bad_request
        end
        taken = User.where(agency_name_normalized: name).exists?
        render json: { available: !taken }
      end

      def explore
        agency = User.where(role: :planner, slug: params[:slug]).first
        if agency
          render json: agency, serializer: AgencySerializer
        else
          render json: { error: "Agency not found" }, status: :not_found
        end
      end

      private

      def agency_params
        params.permit(:agency_name, :agency_tagline, :bio, :city, :phone, :years_experience,
                      :youtube_url, :instagram_url, :tiktok_url, :twitter_url, :website_url)
      end

    end
  end
end
