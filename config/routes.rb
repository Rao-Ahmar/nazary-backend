Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Auth
      post   "auth/signup",          to: "auth#signup"
      post   "auth/login",           to: "auth#login"
      delete "auth/logout",          to: "auth#logout"
      get    "auth/me",              to: "auth#me"
      post   "auth/forgot_password", to: "auth#forgot_password"
      post   "auth/reset_password",  to: "auth#reset_password"
      post   "auth/refresh",         to: "auth#refresh"
      post   "auth/google",          to: "auth#google"

      # User profile
      patch "users/me",              to: "users#update"
      patch "users/me/avatar",       to: "users#update_avatar"
      patch "users/me/agency_logo",  to: "users#update_agency_logo"
      patch "users/me/cover_photo",  to: "users#update_cover_photo"
      post  "users/me/device_token", to: "users#register_device_token"
      get   "users/:id",            to: "users#show"

      # OTP Verification
      post "otp/send", to: "otp#send_code"
      post "otp/verify", to: "otp#verify"

      # Trips (public browsing)
      get "trips/featured", to: "trips#featured", as: :featured_trips
      resources :trips, only: [ :index, :show ] do
        resources :reviews, only: [ :index, :create ]
        resources :bookings, only: [ :create ]
      end

      # Traveler bookings
      resources :bookings, only: [ :index, :show ] do
        patch :cancel, on: :member
        get :payment_info, on: :member
        post :payment_proof, on: :member, to: "bookings#submit_payment_proof"
      end

      # Trip Requests (traveler)
      resources :trip_requests, only: [ :index, :create ] do
        patch :cancel, on: :member
      end

      # Notifications
      resources :notifications, only: [ :index ] do
        patch :read, on: :member, to: "notifications#mark_read"
      end
      patch "notifications/read_all", to: "notifications#read_all"

      # Trip Preferences
      get "trip_preferences", to: "trip_preferences#show"
      put "trip_preferences", to: "trip_preferences#upsert"

      # Planner Reviews
      post "planner_reviews", to: "planner_reviews#create"
      get  "users/:user_id/reviews", to: "planner_reviews#index"

      # Places (public)
      resources :places, only: [ :index, :show ] do
        resources :place_reviews, only: [ :index, :create ], path: "reviews"
      end

      # REMOVED: messaging feature — Nazary v1
      # resources :conversations, only: [ :index, :create ] do
      #   resources :messages, only: [ :index, :create ]
      #   patch "messages/read", to: "messages#mark_read"
      # end

      # Categories & Collections
      resources :categories, only: [ :index ]
      resources :collections, only: [ :index, :show ]

      # Agencies (public)
      get "agencies/check-name", to: "agencies#check_name"
      get "explore/:slug", to: "agencies#explore"
      resources :agencies, only: [ :index, :show, :update ] do
        get :trips, on: :member
      end

      # Arrangement Requests
      resources :arrangement_requests, only: [ :create ]
      get "my/arrangement_requests", to: "arrangement_requests#my_requests"

      # Couple Requests
      resources :couple_requests, only: [ :create, :index ]

      # Corporate Trip Requests
      resources :corporate_trip_requests, only: [ :create, :index ]

      # Feedback Submissions
      resources :feedback_submissions, only: [ :create ]

      # Points
      get "points/me", to: "points#me"

      # Planner namespace
      namespace :planner do
        get "stats", to: "stats#index"

        resources :trips, only: [ :index, :create, :update, :destroy ] do
          patch :publish, on: :member
          patch :complete, on: :member
          patch :update_seats, on: :member
          post  :hero_image, on: :member
          post  :gallery, on: :member
          post  :reschedule, on: :member
          patch :stop_recurring, on: :member
        end

        resources :bookings, only: [ :index ] do
          patch :confirm, on: :member
          patch :cancel, on: :member
        end

        resources :trip_requests, only: [ :index ] do
          patch :accept, on: :member
          patch :reject, on: :member
        end

        resources :itinerary_presets, only: [ :index, :create, :update, :destroy ]
      end

      # Admin namespace
      namespace :admin do
        resources :agencies, only: [ :index ] do
          patch :verify, on: :member
          patch :deactivate, on: :member
        end
        resources :trips, only: [ :index ] do
          patch :cancel, on: :member
        end
        resources :arrangement_requests, only: [ :index, :update ]
        resources :couple_requests, only: [ :index, :update ]
        resources :corporate_trip_requests, only: [ :index, :update ]
        resources :trip_requests, only: [ :index ] do
          patch :approve, on: :member
          patch :reject, on: :member
        end
        resources :users, only: [ :index ] do
          patch :deactivate, on: :member
        end

        # Booking management
        resources :bookings, only: [ :index, :show ] do
          patch :approve, on: :member
          patch :reject, on: :member
          patch :verify_payment, on: :member
          patch :reject_payment, on: :member
          patch :confirm, on: :member
          patch :cancel, on: :member
        end

        # Rewards
        resources :rewards, only: [ :index ] do
          patch :mark_gift_sent, on: :member
          patch :mark_free_trip_arranged, on: :member
        end

        # Lucky draw
        get :lucky_draw_eligible, to: "lucky_draw#eligible"

        # Payment account settings
        resources :payment_accounts, only: [ :index, :create, :update, :destroy ]

        # Dashboard stats
        get :stats, to: "stats#index"
      end

      # Bike namespace (premium)
      namespace :bike do
        get "trips", to: "trips#index"
        get "riders", to: "riders#index"
        get "profile", to: "profiles#show"
        post "profile", to: "profiles#create"
        patch "profile", to: "profiles#update"
      end
    end
  end

  # Action Cable
  mount ActionCable.server => "/cable"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
