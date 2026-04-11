# Nazary Backend - Reference Guide

> Rails 8.0.4 API backend for a Pakistan travel/tourism marketplace.
> PostgreSQL, JWT auth, Active Storage, Kaminari pagination, pg_search.

---

## Tech Stack

- **Framework:** Rails 8.0.4 (API-only)
- **Database:** PostgreSQL
- **Auth:** bcrypt (has_secure_password) + JWT (30-day expiry) + refresh tokens
- **Serialization:** ActiveModelSerializers
- **Pagination:** Kaminari (max 50/page)
- **Search:** pg_search (prefix matching on title, location, description)
- **File Uploads:** Active Storage (S3 ready)
- **Push Notifications:** Expo Push API (replaced FCM)
- **Background Jobs:** Solid Queue
- **WebSockets:** Action Cable (Solid Cable)
- **Caching:** Solid Cache + Redis

---

## User Roles

| Role | enum value | Description |
|------|-----------|-------------|
| `traveler` | 0 | Browses trips, books, writes reviews, sends trip requests |
| `planner` | 1 | Manages agency, creates trips, handles bookings/requests |
| `admin` | boolean flag | Admin endpoints access (toggle verified, deactivate users) |

---

## Models

### User
**Table:** `users`
**Key Fields:** name, email, password_digest, role (enum: traveler=0, planner=1), phone, bio, guild, agency_name, agency_tagline, years_experience, cnic_number, city, profile_completed, device_token, premium, admin, verified, deactivated, notifications_enabled (boolean, default: true), youtube_url, instagram_url, tiktok_url, twitter_url, website_url, password_reset_token, password_reset_sent_at, refresh_token, avatar (Active Storage), agency_logo (Active Storage), cover_photo (Active Storage)
**Associations:** trips (as host), bookings, reviews, trip_requests, received_trip_requests, notifications, planner_reviews_given/received, place_reviews, bike_profile, arrangement_requests_as_traveler, trip_preference
**Scopes:** `active` (not deactivated), `verified_planners`
**Methods:** profile_completed?, premium?, average_planner_rating, generate_password_reset_token!, password_reset_valid?, clear_password_reset!, generate_refresh_token!

### Trip
**Table:** `trips`
**Key Fields:** user_id (host), title, subtitle, description, location, price (decimal), currency (default "USD"), duration, start_date, end_date, total_seats, status (enum: draft=0, active=1, completed=2, cancelled=3), highlights (text[]), tags (string[], GIN indexed)
**Associations:** host (User), hero_image (attachment), gallery (attachments), itinerary_days, bookings, reviews, collections
**Scopes:** `featured` (active, newest 10), `by_category(tag)`
**Search:** `search_by_text(query)` — pg_search on title, location, description
**Methods:** seats_left, average_rating

### Booking
**Table:** `bookings`
**Key Fields:** trip_id, user_id, status (enum: pending=0, confirmed=1, cancelled=2), amount (decimal)
**Validations:** unique (trip_id, user_id), user must be traveler

### Review
**Table:** `reviews`
**Key Fields:** trip_id, user_id, rating (1-5), text
**Validations:** unique (trip_id, user_id)

### TripRequest
**Table:** `trip_requests`
**Key Fields:** user_id (traveler), planner_id, destination, start_date, end_date, seats, category, budget (decimal), note, status (enum: pending=0, accepted=1, rejected=2, cancelled=3)
**Validations:** end_date > start_date, user is traveler, planner is planner

### ItineraryDay
**Table:** `itinerary_days`
**Key Fields:** trip_id, day (integer), title, desc
**Default scope:** ordered by day

### Notification
**Table:** `notifications`
**Key Fields:** user_id, title, body, notification_type (enum: trip_reminder=0, booking_update=1, request_update=2, review=3, general=4, bike_trip=5, new_trip=7, preference_match=8), data (jsonb), read (boolean)
**Scopes:** `unread`, `recent`

### PlannerReview
**Table:** `planner_reviews`
**Key Fields:** user_id (reviewer), planner_id, rating (1-5), text
**Validations:** unique (user_id, planner_id), reviewer must be traveler, target must be planner

### Place
**Table:** `places`
**Key Fields:** name, region, description, latitude (decimal), longitude (decimal), cover_image (attachment)
**Methods:** average_rating, review_count

### PlaceReview
**Table:** `place_reviews`
**Key Fields:** place_id, user_id, rating (1-5), text

### BikeProfile
**Table:** `bike_profiles`
**Key Fields:** user_id (unique), bike_model, bike_cc (integer), experience_level (enum: beginner=0, intermediate=1, advanced=2), bio

### ArrangementRequest
**Table:** `arrangement_requests`
**Key Fields:** traveler_id, preferred_destination, travel_dates, group_size (default 1), budget_min (decimal), budget_max (decimal), special_notes, status (enum: pending=0, in_review=1, arranged=2, rejected=3), linked_trip_id (nullable FK to trips)

### Category
**Table:** `categories`
**Key Fields:** label (unique), icon

### Collection / CollectionTrip
**Tables:** `collections`, `collection_trips`
**Fields:** title, subtitle, cover_image; collection_id + trip_id join

### TripPreference
**Table:** `trip_preferences`
**Key Fields:** user_id (unique FK), budget_min (decimal), budget_max (decimal), preferred_months (integer[], GIN indexed), followed_agency_id (FK to users, nullable)
**Associations:** belongs_to user, belongs_to followed_agency (User, optional)
**Validations:** uniqueness on user_id, budget_max > budget_min, followed_agency must be planner

### Messaging (REMOVED in v1)
Conversation, ConversationParticipant, Message — tables exist, models commented out.

---

## API Routes

### Auth (public)
```
POST   /api/v1/auth/signup
POST   /api/v1/auth/login
DELETE  /api/v1/auth/logout
GET    /api/v1/auth/me
POST   /api/v1/auth/forgot_password
POST   /api/v1/auth/reset_password
POST   /api/v1/auth/refresh
```

### Users
```
GET    /api/v1/users/:id
PATCH  /api/v1/users/me
PATCH  /api/v1/users/me/avatar
PATCH  /api/v1/users/me/agency_logo
POST   /api/v1/users/me/device_token
PATCH  /api/v1/users/me/cover_photo
```

### Trips (public browsing)
```
GET    /api/v1/trips                      (filterable: q, tag, min_price, max_price, sort)
GET    /api/v1/trips/featured
GET    /api/v1/trips/:id
GET    /api/v1/trips/:trip_id/reviews
POST   /api/v1/trips/:trip_id/reviews
POST   /api/v1/trips/:trip_id/bookings
```

### Bookings (traveler)
```
GET    /api/v1/bookings
GET    /api/v1/bookings/:id
PATCH  /api/v1/bookings/:id/cancel
```

### Trip Requests (traveler)
```
GET    /api/v1/trip_requests
POST   /api/v1/trip_requests
PATCH  /api/v1/trip_requests/:id/cancel
```

### Notifications
```
GET    /api/v1/notifications
PATCH  /api/v1/notifications/:id/read
PATCH  /api/v1/notifications/read_all
```

### Planner Reviews
```
POST   /api/v1/planner_reviews
GET    /api/v1/users/:user_id/reviews
```

### Places (public)
```
GET    /api/v1/places                     (filterable: region)
GET    /api/v1/places/:id
GET    /api/v1/places/:place_id/reviews
POST   /api/v1/places/:place_id/reviews
```

### Categories & Collections (public)
```
GET    /api/v1/categories
GET    /api/v1/collections
GET    /api/v1/collections/:id
```

### Agencies (public)
```
GET    /api/v1/agencies                   (verified only)
GET    /api/v1/agencies/:id
PATCH  /api/v1/agencies/:id              (owner only)
GET    /api/v1/agencies/:id/trips
```

### Trip Preferences (traveler)
```
GET    /api/v1/trip_preferences
PUT    /api/v1/trip_preferences
```

### Arrangements
```
POST   /api/v1/arrangement_requests       (traveler only)
GET    /api/v1/my/arrangement_requests
```

### Planner Namespace (requires planner role)
```
GET    /api/v1/planner/stats
GET    /api/v1/planner/trips
POST   /api/v1/planner/trips
PATCH  /api/v1/planner/trips/:id
DELETE /api/v1/planner/trips/:id          (draft only)
PATCH  /api/v1/planner/trips/:id/publish
PATCH  /api/v1/planner/trips/:id/complete
POST   /api/v1/planner/trips/:id/hero_image
POST   /api/v1/planner/trips/:id/gallery
GET    /api/v1/planner/bookings
PATCH  /api/v1/planner/bookings/:id/confirm
PATCH  /api/v1/planner/bookings/:id/cancel
GET    /api/v1/planner/trip_requests
PATCH  /api/v1/planner/trip_requests/:id/accept
PATCH  /api/v1/planner/trip_requests/:id/reject
```

### Admin Namespace (requires admin flag)
```
GET    /api/v1/admin/agencies
PATCH  /api/v1/admin/agencies/:id/verify
PATCH  /api/v1/admin/agencies/:id/deactivate
GET    /api/v1/admin/trips
PATCH  /api/v1/admin/trips/:id/cancel
GET    /api/v1/admin/arrangement_requests
PATCH  /api/v1/admin/arrangement_requests/:id
GET    /api/v1/admin/users
PATCH  /api/v1/admin/users/:id/deactivate
```

### Bike (requires premium)
```
GET    /api/v1/bike/trips
GET    /api/v1/bike/riders
GET    /api/v1/bike/profile
POST   /api/v1/bike/profile
PATCH  /api/v1/bike/profile
```

---

## Serializers

| Serializer | Key Fields |
|------------|-----------|
| UserSerializer | id, name, email, role, avatar, phone, profile_completed, notifications_enabled; planner extras: bio, guild, rating, agency_name, agency_tagline, years_experience, agency_logo, planner_rating, youtube_url, instagram_url, tiktok_url, twitter_url, website_url, cover_photo |
| TripListSerializer | id, title, location, hero_image, price, currency, duration, dates, seats_left, tags, rating, review_count, host |
| TripDetailSerializer | extends TripList + subtitle, description, gallery, total_seats, status, highlights, itinerary, created_at |
| TripHostSerializer | id, name, avatar, guild, rating |
| BookingSerializer | id, trip_id, traveler_id, traveler_name, status, amount; conditional: trip_title |
| ReviewSerializer | id, trip_id, user_id, name, avatar, rating, text, date |
| TripRequestSerializer | id, traveler/planner info, destination, dates, seats, budget, status; conditional: phone numbers (only when accepted) |
| NotificationSerializer | id, title, body, notification_type, data, read, created_at |
| PlaceSerializer | id, name, region, description, lat/lng, cover_image, rating, review_count |
| AgencySerializer | id, agency_name, name, bio, tagline, city, phone (conditional), verified, average_rating, total_trips, avatar, agency_logo, years_experience, youtube_url, instagram_url, tiktok_url, twitter_url, website_url, cover_photo |
| ArrangementRequestSerializer | id, destination, dates, group_size, budget_min/max, special_notes, status, linked_trip_id, traveler |
| TripPreferenceSerializer | id, budget_min, budget_max, preferred_months, followed_agency_id, followed_agency_name |
| BikeProfileSerializer | id, user_id, user_name, user_avatar, bike_model, bike_cc, experience_level, bio |

---

## Services

| Service | Purpose |
|---------|---------|
| JwtService | encode(user_id) / decode(token) — 30-day expiry |
| NotificationService | Creates DB notification + sends Expo push (checks notifications_enabled) |
| ExpoPushService | Sends push notifications via Expo Push API (no credentials needed) |

---

## Auth Flow

1. **Signup/Login** returns `{ user, token, refresh_token }`
2. Client sends `Authorization: Bearer <token>` on every request
3. When JWT expires, client calls `POST /auth/refresh` with refresh_token to get new pair
4. **Password reset**: forgot_password generates token (2h expiry) -> email (not implemented yet) -> reset_password validates token and sets new password
5. **Deactivated users** get 403 on login

---

## Seeds

**Admin:** admin@nazary.pk / NazaryAdmin2024!
**Default Agency:** agency@nazary.pk / Nazary2024! (the "Nazary" agency for arranged trips)
**Planners:** alex@nazary.com, fatima@nazary.com (both verified, premium)
**Travelers:** traveler@nazary.com, ahmed@nazary.com
**Places:** 22 Pakistan destinations (Hunza, Fairy Meadows, Skardu, Swat, Neelum, Lahore, Mohenjo-daro, Attabad Lake, Kumrat, Murree, Ratti Gali, Deosai, Shigar, Khunjerab, Naltar, Rakaposhi, Shogran, Kalam, Chitral, Malam Jabba, Nathia Gali, Raikot)
**Categories:** All, Adventure, Cultural, Wellness, Culinary, Safari, Bike

---

## Directory Structure

```
app/
  controllers/api/v1/
    auth_controller.rb
    users_controller.rb
    trips_controller.rb
    bookings_controller.rb
    reviews_controller.rb
    trip_requests_controller.rb
    notifications_controller.rb
    planner_reviews_controller.rb
    places_controller.rb
    place_reviews_controller.rb
    categories_controller.rb
    collections_controller.rb
    agencies_controller.rb
    arrangement_requests_controller.rb
    trip_preferences_controller.rb
    base_controller.rb
    planner/
      base_controller.rb
      trips_controller.rb
      bookings_controller.rb
      trip_requests_controller.rb
      stats_controller.rb
    admin/
      base_controller.rb
      agencies_controller.rb
      trips_controller.rb
      arrangement_requests_controller.rb
      users_controller.rb
    bike/
      base_controller.rb
      trips_controller.rb
      riders_controller.rb
      profiles_controller.rb
  controllers/concerns/
    authenticatable.rb
    authorizable.rb
    paginatable.rb
    profile_completable.rb
  models/
    user.rb, trip.rb, booking.rb, review.rb, trip_request.rb,
    itinerary_day.rb, notification.rb, planner_review.rb,
    place.rb, place_review.rb, bike_profile.rb,
    category.rb, collection.rb, collection_trip.rb,
    arrangement_request.rb, trip_preference.rb
  serializers/
    user_serializer.rb, trip_list_serializer.rb, trip_detail_serializer.rb,
    trip_host_serializer.rb, booking_serializer.rb, review_serializer.rb,
    trip_request_serializer.rb, notification_serializer.rb,
    planner_review_serializer.rb, place_serializer.rb,
    place_review_serializer.rb, bike_profile_serializer.rb,
    agency_serializer.rb, arrangement_request_serializer.rb,
    trip_preference_serializer.rb
  services/
    jwt_service.rb, notification_service.rb, expo_push_service.rb
  jobs/
    notify_new_trip_job.rb, trip_reminder_job.rb
```

---

## Removed Features

**Messaging (Nazary v1):** Conversations, messages, conversation_participants — tables exist but models/controllers commented out, routes commented out. Contact between traveler and agency now happens via phone call after trip request is accepted.
