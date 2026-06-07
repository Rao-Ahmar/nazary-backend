module Api
  module V1
    class CollectionsController < BaseController
      def index
        collections = Collection.all.includes(cover_image_attachment: :blob)
        render json: {
          data: collections.map { |c|
            {
              id: c.id.to_s,
              title: c.title,
              subtitle: c.subtitle,
              image: c.cover_image.attached? ? Rails.application.routes.url_helpers.url_for(c.cover_image) : nil
            }
          }
        }
      end

      def show
        collection = Collection.includes(trips: [ :bookings, { hero_image_attachment: :blob, host: { avatar_attachment: :blob } } ])
                               .find(params[:id])
        render json: {
          id: collection.id.to_s,
          title: collection.title,
          subtitle: collection.subtitle,
          image: collection.cover_image.attached? ? Rails.application.routes.url_helpers.url_for(collection.cover_image) : nil,
          trips: ActiveModelSerializers::SerializableResource.new(
            collection.trips, each_serializer: TripListSerializer
          ).as_json
        }
      end
    end
  end
end
