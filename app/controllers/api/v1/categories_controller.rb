module Api
  module V1
    class CategoriesController < BaseController
      def index
        categories = Category.all
        render json: { data: categories.map { |c| { id: c.id.to_s, label: c.label, icon: c.icon } } }
      end
    end
  end
end
