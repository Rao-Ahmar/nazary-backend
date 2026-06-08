# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_06_08_074720) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "arrangement_requests", force: :cascade do |t|
    t.bigint "traveler_id", null: false
    t.text "preferred_destination"
    t.text "travel_dates"
    t.integer "group_size", default: 1, null: false
    t.decimal "budget_min", precision: 10, scale: 2
    t.decimal "budget_max", precision: 10, scale: 2
    t.text "special_notes"
    t.integer "status", default: 0, null: false
    t.bigint "linked_trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "agency_id"
    t.index ["agency_id"], name: "index_arrangement_requests_on_agency_id"
    t.index ["linked_trip_id"], name: "index_arrangement_requests_on_linked_trip_id"
    t.index ["status"], name: "index_arrangement_requests_on_status"
    t.index ["traveler_id"], name: "index_arrangement_requests_on_traveler_id"
  end

  create_table "bike_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "bike_model", null: false
    t.integer "bike_cc", null: false
    t.integer "experience_level", default: 0, null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bike_profiles_on_user_id", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.bigint "user_id", null: false
    t.integer "status", default: 0, null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "admin_note"
    t.integer "seats", default: 1, null: false
    t.boolean "admin_approved", default: false, null: false
    t.index ["status"], name: "index_bookings_on_status"
    t.index ["trip_id", "user_id"], name: "index_bookings_on_trip_id_and_user_id", unique: true
    t.index ["trip_id"], name: "index_bookings_on_trip_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "label", null: false
    t.string "icon", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collection_trips", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "trip_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_collection_trips_on_collection_id"
    t.index ["trip_id"], name: "index_collection_trips_on_trip_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversation_participants", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id", "user_id"], name: "index_conversation_participants_on_conversation_id_and_user_id", unique: true
    t.index ["conversation_id"], name: "index_conversation_participants_on_conversation_id"
    t.index ["user_id"], name: "index_conversation_participants_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_conversations_on_trip_id"
  end

  create_table "corporate_trip_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "company_name", null: false
    t.integer "estimated_people", null: false
    t.string "contact_email"
    t.string "contact_phone"
    t.text "special_notes"
    t.integer "status", default: 0, null: false
    t.text "admin_note"
    t.bigint "preferred_planner_id"
    t.bigint "linked_trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_corporate_trip_requests_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_corporate_trip_requests_on_user_id"
  end

  create_table "couple_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "partner_name", null: false
    t.string "destination_preference", null: false
    t.string "travel_dates", null: false
    t.string "budget_range", null: false
    t.text "special_requests"
    t.integer "status", default: 0, null: false
    t.bigint "linked_trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["linked_trip_id"], name: "index_couple_requests_on_linked_trip_id"
    t.index ["user_id"], name: "index_couple_requests_on_user_id"
  end

  create_table "feedback_submissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "subject", null: false
    t.text "message", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_feedback_submissions_on_status"
    t.index ["user_id"], name: "index_feedback_submissions_on_user_id"
  end

  create_table "itinerary_days", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.integer "day", null: false
    t.string "title", null: false
    t.text "desc", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_itinerary_days_on_trip_id"
  end

  create_table "itinerary_presets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.jsonb "days", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_itinerary_presets_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_itinerary_presets_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "sender_id", null: false
    t.text "body", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.integer "notification_type", default: 4, null: false
    t.jsonb "data", default: {}
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_type"], name: "index_notifications_on_notification_type"
    t.index ["user_id", "read"], name: "index_notifications_on_user_id_and_read"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "otp_verifications", force: :cascade do |t|
    t.string "phone_number", null: false
    t.string "code", null: false
    t.datetime "expires_at", null: false
    t.boolean "verified", default: false
    t.integer "attempts", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_number", "code"], name: "index_otp_verifications_on_phone_number_and_code"
  end

  create_table "payment_accounts", force: :cascade do |t|
    t.integer "method_type", null: false
    t.string "account_title", null: false
    t.string "account_number", null: false
    t.string "bank_name"
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_active"], name: "index_payment_accounts_on_is_active"
    t.index ["method_type"], name: "index_payment_accounts_on_method_type"
  end

  create_table "payment_proofs", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.string "reference_number", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "method_used", null: false
    t.integer "status", default: 0, null: false
    t.text "admin_note"
    t.datetime "verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payment_proofs_on_booking_id"
    t.index ["status"], name: "index_payment_proofs_on_status"
  end

  create_table "place_reviews", force: :cascade do |t|
    t.bigint "place_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id", "user_id"], name: "index_place_reviews_on_place_id_and_user_id", unique: true
    t.index ["place_id"], name: "index_place_reviews_on_place_id"
    t.index ["user_id"], name: "index_place_reviews_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name", null: false
    t.string "region", null: false
    t.text "description"
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "elevation_meters"
    t.index ["region"], name: "index_places_on_region"
  end

  create_table "planner_reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "planner_id", null: false
    t.integer "rating", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planner_id"], name: "index_planner_reviews_on_planner_id"
    t.index ["user_id", "planner_id"], name: "index_planner_reviews_on_user_id_and_planner_id", unique: true
    t.index ["user_id"], name: "index_planner_reviews_on_user_id"
  end

  create_table "points_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "points", null: false
    t.string "reason", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_points_logs_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_points_logs_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id", "user_id"], name: "index_reviews_on_trip_id_and_user_id", unique: true
    t.index ["trip_id"], name: "index_reviews_on_trip_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "trip_preferences", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "budget_min", precision: 10, scale: 2
    t.decimal "budget_max", precision: 10, scale: 2
    t.integer "preferred_months", default: [], array: true
    t.bigint "followed_agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_agency_id"], name: "index_trip_preferences_on_followed_agency_id"
    t.index ["preferred_months"], name: "index_trip_preferences_on_preferred_months", using: :gin
    t.index ["user_id"], name: "index_trip_preferences_on_user_id", unique: true
  end

  create_table "trip_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "planner_id", null: false
    t.string "destination", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "seats", null: false
    t.string "category"
    t.decimal "budget", precision: 10, scale: 2
    t.text "note"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin_approved", default: false, null: false
    t.index ["planner_id"], name: "index_trip_requests_on_planner_id"
    t.index ["status"], name: "index_trip_requests_on_status"
    t.index ["user_id"], name: "index_trip_requests_on_user_id"
  end

  create_table "trip_updates", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.bigint "editor_id", null: false
    t.jsonb "field_changes", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["editor_id"], name: "index_trip_updates_on_editor_id"
    t.index ["trip_id"], name: "index_trip_updates_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "subtitle"
    t.text "description", null: false
    t.string "location", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.string "currency", default: "USD", null: false
    t.string "duration", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "total_seats", null: false
    t.integer "status", default: 0, null: false
    t.text "highlights", default: [], array: true
    t.string "tags", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trip_type", default: 0
    t.boolean "is_premium", default: false
    t.datetime "content_updated_at"
    t.bigint "source_trip_id"
    t.boolean "recurring_enabled", default: false, null: false
    t.jsonb "recurring_rule"
    t.integer "seats_sold", default: 0, null: false
    t.integer "reviews_count", default: 0, null: false
    t.decimal "cached_average_rating", precision: 3, scale: 1, default: "0.0", null: false
    t.index ["location"], name: "index_trips_on_location_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["recurring_enabled"], name: "index_trips_on_recurring_enabled"
    t.index ["source_trip_id"], name: "index_trips_on_source_trip_id"
    t.index ["start_date"], name: "index_trips_on_start_date"
    t.index ["status", "start_date"], name: "index_trips_on_status_and_start_date"
    t.index ["status"], name: "index_trips_on_status"
    t.index ["tags"], name: "index_trips_on_tags", using: :gin
    t.index ["title"], name: "index_trips_on_title_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["trip_type"], name: "index_trips_on_trip_type"
    t.index ["user_id"], name: "index_trips_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.integer "role", default: 0, null: false
    t.string "phone"
    t.text "bio"
    t.string "guild"
    t.boolean "online", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "agency_name"
    t.string "agency_tagline"
    t.integer "years_experience"
    t.string "cnic_number"
    t.boolean "profile_completed", default: false
    t.string "device_token"
    t.boolean "premium", default: false
    t.boolean "admin", default: false, null: false
    t.boolean "verified", default: false, null: false
    t.boolean "deactivated", default: false, null: false
    t.string "city"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string "refresh_token"
    t.boolean "phone_verified", default: false
    t.string "youtube_url"
    t.string "instagram_url"
    t.string "tiktok_url"
    t.string "twitter_url"
    t.string "website_url"
    t.boolean "notifications_enabled", default: true, null: false
    t.string "slug"
    t.string "agency_name_normalized"
    t.boolean "instagram_verified", default: false
    t.boolean "tiktok_verified", default: false
    t.datetime "social_verified_at"
    t.string "google_uid"
    t.string "referral_code"
    t.bigint "referred_by_user_id"
    t.integer "points", default: 0, null: false
    t.integer "completed_trips_count", default: 0, null: false
    t.boolean "surprise_gift_eligible", default: false
    t.boolean "surprise_gift_sent", default: false
    t.boolean "free_trip_eligible", default: false
    t.boolean "free_trip_arranged", default: false
    t.bigint "free_trip_pair_user_id"
    t.integer "corporate_trips_count", default: 0, null: false
    t.string "corporate_level", default: "none"
    t.integer "trips_count", default: 0, null: false
    t.decimal "cached_host_rating", precision: 3, scale: 1, default: "0.0", null: false
    t.index ["agency_name_normalized"], name: "index_users_on_agency_name_normalized", unique: true, where: "(agency_name_normalized IS NOT NULL)"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_uid"], name: "index_users_on_google_uid", unique: true, where: "(google_uid IS NOT NULL)"
    t.index ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true
    t.index ["referral_code"], name: "index_users_on_referral_code", unique: true
    t.index ["referred_by_user_id"], name: "index_users_on_referred_by_user_id"
    t.index ["refresh_token"], name: "index_users_on_refresh_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true, where: "(slug IS NOT NULL)"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "arrangement_requests", "trips", column: "linked_trip_id"
  add_foreign_key "arrangement_requests", "users", column: "agency_id"
  add_foreign_key "arrangement_requests", "users", column: "traveler_id"
  add_foreign_key "bike_profiles", "users"
  add_foreign_key "bookings", "trips"
  add_foreign_key "bookings", "users"
  add_foreign_key "collection_trips", "collections"
  add_foreign_key "collection_trips", "trips"
  add_foreign_key "conversation_participants", "conversations"
  add_foreign_key "conversation_participants", "users"
  add_foreign_key "conversations", "trips"
  add_foreign_key "corporate_trip_requests", "trips", column: "linked_trip_id"
  add_foreign_key "corporate_trip_requests", "users"
  add_foreign_key "corporate_trip_requests", "users", column: "preferred_planner_id"
  add_foreign_key "couple_requests", "trips", column: "linked_trip_id"
  add_foreign_key "couple_requests", "users"
  add_foreign_key "feedback_submissions", "users"
  add_foreign_key "itinerary_days", "trips"
  add_foreign_key "itinerary_presets", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "payment_proofs", "bookings"
  add_foreign_key "place_reviews", "places"
  add_foreign_key "place_reviews", "users"
  add_foreign_key "planner_reviews", "users"
  add_foreign_key "planner_reviews", "users", column: "planner_id"
  add_foreign_key "points_logs", "users"
  add_foreign_key "reviews", "trips"
  add_foreign_key "reviews", "users"
  add_foreign_key "trip_preferences", "users"
  add_foreign_key "trip_preferences", "users", column: "followed_agency_id"
  add_foreign_key "trip_requests", "users"
  add_foreign_key "trip_requests", "users", column: "planner_id"
  add_foreign_key "trip_updates", "trips"
  add_foreign_key "trip_updates", "users", column: "editor_id"
  add_foreign_key "trips", "trips", column: "source_trip_id", on_delete: :nullify
  add_foreign_key "trips", "users"
  add_foreign_key "users", "users", column: "free_trip_pair_user_id"
  add_foreign_key "users", "users", column: "referred_by_user_id"
end
