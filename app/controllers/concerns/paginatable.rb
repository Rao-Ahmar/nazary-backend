module Paginatable
  extend ActiveSupport::Concern

  private

  def paginate(collection)
    paginated = collection.page(params[:page] || 1).per([ params[:per_page]&.to_i || 10, 50 ].min)
    {
      data: paginated,
      meta: {
        currentPage: paginated.current_page,
        totalPages: paginated.total_pages,
        totalCount: paginated.total_count
      }
    }
  end
end
