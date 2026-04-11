module Api
  module V1
    class TripPreferencesController < BaseController
      def show
        preference = current_user.trip_preference
        if preference
          render json: preference, serializer: TripPreferenceSerializer
        else
          render json: { data: nil }
        end
      end

      def upsert
        preference = current_user.trip_preference || current_user.build_trip_preference

        if preference.update(preference_params)
          render json: preference, serializer: TripPreferenceSerializer
        else
          render json: { error: preference.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      private

      def preference_params
        params.permit(:budget_min, :budget_max, :followed_agency_id, preferred_months: [])
      end
    end
  end
end
