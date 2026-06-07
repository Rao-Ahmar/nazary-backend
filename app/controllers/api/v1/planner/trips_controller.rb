module Api
  module V1
    module Planner
      class TripsController < Planner::BaseController
        before_action :set_trip, only: [ :update, :destroy, :publish, :complete, :hero_image, :gallery, :update_seats, :reschedule, :stop_recurring ]
        before_action :require_avatar, only: [ :create ]

        def index
          trips = current_user.trips.includes(:bookings, hero_image_attachment: :blob)

          # Search
          trips = trips.search_by_text(params[:q]) if params[:q].present?

          # Filters
          trips = trips.where(status: params[:status]) if params[:status].present?
          trips = trips.by_price_range(params[:min_price], params[:max_price])
          trips = trips.by_date_range(params[:start_date_from], params[:start_date_to])

          trips = trips.order(created_at: :desc)
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
          old_attributes = @trip.attributes.slice("title", "description", "location", "price", "duration", "start_date", "end_date")

          if @trip.update(trip_params)
            update_itinerary_days(@trip) if params[:itinerary_days].present?

            # Track changes (total_seats excluded — seat changes don't notify travelers)
            new_attributes = @trip.attributes.slice("title", "description", "location", "price", "duration", "start_date", "end_date")
            changed_fields = {}
            old_attributes.each do |key, old_val|
              new_val = new_attributes[key]
              if old_val.to_s != new_val.to_s
                changed_fields[key] = { from: old_val, to: new_val }
              end
            end

            if changed_fields.any?
              trip_update = @trip.trip_updates.new(editor: current_user, field_changes: changed_fields)
              trip_update.save!
              @trip.update_column(:content_updated_at, Time.current)

              # Notify all associated travelers (pending and confirmed)
              @trip.bookings.active.includes(:user).each do |booking|
                NotificationService.create(
                  user: booking.user,
                  title: "Trip Updated",
                  body: "#{@trip.title} has been updated. Please call the planner to confirm.",
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
          # TODO: Re-enable once social verification flow is fully in place.
          # For now, travelers verify agencies manually by checking their Nazary link in Instagram/TikTok bio.
          # unless current_user.social_verified?
          #   return render json: { error: "You must verify at least one social account (Instagram or TikTok) before publishing trips." }, status: :forbidden
          # end

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
            award_points_for_completed_trip
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
          desired_left = params[:seats_left].to_i
          confirmed_count = @trip.bookings.confirmed.count
          max_left = @trip.total_seats - confirmed_count

          if desired_left < 0
            render json: { error: "Seats left cannot be negative" }, status: :unprocessable_entity
            return
          end

          if desired_left > max_left
            render json: { error: "Seats left cannot exceed #{max_left} (total #{@trip.total_seats} minus #{confirmed_count} confirmed)" }, status: :unprocessable_entity
            return
          end

          new_seats_sold = max_left - desired_left
          @trip.update!(seats_sold: new_seats_sold)
          render json: @trip, serializer: TripDetailSerializer
        end

        def reschedule
          new_start = params[:start_date]
          new_end   = params[:end_date]
          new_seats = params[:total_seats]

          unless new_start.present? && new_end.present?
            render json: { error: "start_date and end_date are required" }, status: :unprocessable_entity
            return
          end

          new_trip = current_user.trips.new(
            title: @trip.title,
            subtitle: @trip.subtitle,
            description: @trip.description,
            location: @trip.location,
            price: @trip.price,
            currency: @trip.currency,
            duration: @trip.duration,
            start_date: new_start,
            end_date: new_end,
            total_seats: new_seats.present? ? new_seats.to_i : @trip.total_seats,
            trip_type: @trip.trip_type,
            tags: @trip.tags,
            highlights: @trip.highlights,
            source_trip_id: @trip.id
          )

          if new_trip.save
            # Clone itinerary days
            @trip.itinerary_days.each do |day|
              new_trip.itinerary_days.create!(day: day.day, title: day.title, desc: day.desc)
            end

            # Clone hero image
            if @trip.hero_image.attached?
              new_trip.hero_image.attach(@trip.hero_image.blob)
            end

            # Clone gallery
            @trip.gallery.each do |img|
              new_trip.gallery.attach(img.blob)
            end

            render json: new_trip, serializer: TripDetailSerializer, status: :created
          else
            render json: { error: new_trip.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        def stop_recurring
          if @trip.recurring_enabled?
            @trip.update!(recurring_enabled: false)
            render json: @trip, serializer: TripDetailSerializer
          else
            render json: { error: "Trip is not recurring" }, status: :unprocessable_entity
          end
        end

        private

        def set_trip
          @trip = current_user.trips.find(params[:id])
        end

        def award_points_for_completed_trip
          @trip.bookings.where(status: :confirmed).includes(user: :referred_by).each do |booking|
            traveler = booking.user
            was_first_trip = traveler.completed_trips_count == 0

            PointsService.award_trip_completion(traveler, @trip)

            if was_first_trip && traveler.referred_by.present?
              PointsService.award_referral_bonus(traveler.referred_by, traveler, @trip)
            end
          end
        end

        def trip_params
          params.permit(:title, :subtitle, :description, :location, :price,
                        :currency, :duration, :start_date, :end_date, :total_seats, :trip_type,
                        :recurring_enabled,
                        tags: [], highlights: [],
                        recurring_rule: [ :day_of_week, :hour ])
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
