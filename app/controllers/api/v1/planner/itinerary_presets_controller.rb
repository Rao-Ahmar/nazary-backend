module Api
  module V1
    module Planner
      class ItineraryPresetsController < Planner::BaseController
        before_action :set_preset, only: [ :update, :destroy ]

        def index
          presets = current_user.itinerary_presets.ordered
          render json: presets, each_serializer: ItineraryPresetSerializer
        end

        def create
          preset = current_user.itinerary_presets.new(preset_params)

          if preset.save
            render json: preset, serializer: ItineraryPresetSerializer, status: :created
          else
            render json: { error: preset.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        def update
          if @preset.update(preset_params)
            render json: @preset, serializer: ItineraryPresetSerializer
          else
            render json: { error: @preset.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        def destroy
          @preset.destroy!
          head :no_content
        end

        private

        def set_preset
          @preset = current_user.itinerary_presets.find(params[:id])
        end

        def preset_params
          params.permit(:name, days: [ :day, :title, :desc ])
        end
      end
    end
  end
end
