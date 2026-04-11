module Api
  module V1
    module Admin
      class UsersController < BaseController
        def index
          users = User.order(created_at: :desc)
          users = users.where(role: params[:role]) if params[:role].present?
          result = paginate(users)
          render json: result[:data], each_serializer: UserSerializer, meta: result[:meta]
        end

        def deactivate
          user = User.find(params[:id])
          user.update!(deactivated: true)
          render json: { id: user.id.to_s, deactivated: true }
        end
      end
    end
  end
end
