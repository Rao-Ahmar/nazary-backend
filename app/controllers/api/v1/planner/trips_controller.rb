module Api
  module V1
    module Planner
      class TripsController < Planner::BaseController
        before_action :set_trip, only: [ :update, :destroy, :publish, :complete, :hero_image, :gallery, :update_seats ]
        before_action :require_avatar, only: [ :create ]

        def index
          trips = current_user.trips.includes(:reviews, :bookings, hero_image_attachment: :blob)
                    .order(created_at: :desc)
          result = paginate(trips)
          render json: result[:data], each_serializer: TripListSerializer, meta: result[:meta]
        end

        def create
          trip = current_user.trips.new(trip_params)

          if trip.save
            create_itinerary_days(trip) if params[:itinerary_days].present?
            render json: trip, serializer: TripDetailSerializer, status: :created
          else
            render json: { error: trip.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        def update
          old_attributes = @trip.attributes.slice("title", "description", "location", "price", "duration", "start_date", "end_date", "total_seats")

          if @trip.update(trip_params)
            update_itinerary_days(@trip) if params[:itinerary_days].present?

            # Track changes
            new_attributes = @trip.attributes.slice("title", "description", "location", "price", "duration", "start_date", "end_date", "total_seats")
            changed_fields = {}
            old_attributes.each do |key, old_val|
              new_val = new_attributes[key]
              if old_val.to_s != new_val.to_s
                changed_fields[key] = { from: old_val, to: new_val }
              end
            end

            if changed_fields.any?
              trip_update = @trip.trip_updates.create!(
                editor: current_user,
                changes: changed_fields
              )
              @trip.update_column(:content_updated_at, Time.current)

              # Notify confirmed bookers
              @trip.bookings.confirmed.includes(:user).each do |booking|
                NotificationService.create(
                  user: booking.user,
                  title: "Trip Updated",
                  body: "#{@trip.title} has been updated by the planner",
                  notification_type: :trip_update,
                  data: { trip_id: @trip.id.to_s, trip_update_id: trip_update.id.to_s }
                )
              end
            end

            render json: @trip, serializer: TripDetailSerializer
          else
            render json: { error: @trip.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        def destroy
          if @trip.draft?
            @trip.destroy!
            head :no_content
          else
            render json: { error: "Only draft trips can be deleted" }, status: :unprocessable_entity
          end
        end

        def publish
          if @trip.draft?
            @trip.active!
            NotifyNewTripJob.perform_later(@trip.id)
            render json: @trip, serializer: TripDetailSerializer
          else
            render json: { error: "Only draft trips can be published" }, status: :unprocessable_entity
          end
        end

        def complete
          if @trip.active?
            @trip.completed!
            render json: @trip, serializer: TripDetailSerializer
          else
            render json: { error: "Only active trips can be completed" }, status: :unprocessable_entity
          end
        end

        def hero_image
          if params[:hero_image].present?
            @trip.hero_image.attach(params[:hero_image])
            render json: @trip, serializer: TripDetailSerializer
          else
            render json: { error: "Hero image file is required" }, status: :unprocessable_entity
          end
        end

        def gallery
          if params[:gallery].present?
            @trip.gallery.attach(params[:gallery])
            render json: @trip, serializer: TripDetailSerializer
          else
            render json: { error: "Gallery files are required" }, status: :unprocessable_entity
          end
        end

        def update_seats
          new_total = params[:total_seats].to_i
          confirmed_count = @trip.bookings.confirmed.count

          if new_total < confirmed_count
            render json: { error: "Total seats cannot be less than confirmed bookings (#{confirmed_count})" }, status: :unprocessable_entity
            return
          end

          if new_total < 1
            render json: { error: "Total seats must be at least 1" }, status: :unprocessable_entity
            return
          end

          @trip.update!(total_seats: new_total)
          render json: @trip, serializer: TripDetailSerializer
        end

        private

        def set_trip
          @trip = current_user.trips.find(params[:id])
        end

        def trip_params
          params.permit(:title, :subtitle, :description, :location, :price,
                        :currency, :duration, :start_date, :end_date, :total_seats, :trip_type,
                        tags: [], highlights: [])
        end

        def create_itinerary_days(trip)
          params[:itinerary_days].each do |day_params|
            trip.itinerary_days.create!(
              day: day_params[:day],
              title: day_params[:title],
              desc: day_params[:desc]
            )
          end
        end

        def update_itinerary_days(trip)
          trip.itinerary_days.destroy_all
          create_itinerary_days(trip)
        end

        def require_avatar
          unless current_user.avatar.attached?
            render json: { error: "Profile photo is required to create trips. Please upload your photo in profile settings." }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
