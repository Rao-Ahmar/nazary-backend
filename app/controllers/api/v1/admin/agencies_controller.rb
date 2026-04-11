module Api
  module V1
    module Admin
      class AgenciesController < BaseController
        def index
          agencies = User.where(role: :planner)
          agencies = agencies.where(verified: params[:verified]) if params[:verified].present?
          result = paginate(agencies)
          render json: result[:data], each_serializer: AgencySerializer, show_phone: true, meta: result[:meta]
        end

        def verify
          agency = User.where(role: :planner).find(params[:id])
          agency.update!(verified: !agency.verified)
          render json: { id: agency.id.to_s, verified: agency.verified }
        end

        def deactivate
          agency = User.where(role: :planner).find(params[:id])
          agency.update!(deactivated: true)
          render json: { id: agency.id.to_s, deactivated: true }
        end
      end
    end
  end
end
