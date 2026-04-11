# Nazary API Reference

> Complete API documentation for the Nazary mobile app backend.
> Base URL: `http://localhost:3000/api/v1`

---

## Table of Contents

1. [Overview](#1-overview)
2. [Authentication](#2-authentication)
3. [Error Handling](#3-error-handling)
4. [Endpoints Quick Reference](#4-endpoints-quick-reference)
5. [Auth](#5-auth)
6. [User Profile](#6-user-profile)
7. [Trips (Browse)](#7-trips-browse)
8. [Bookings (Traveler)](#8-bookings-traveler)
9. [Reviews](#9-reviews)
10. [Conversations & Messages](#10-conversations--messages)
11. [Categories & Collections](#11-categories--collections)
12. [Planner — Dashboard Stats](#12-planner--dashboard-stats)
13. [Planner — Trip Management](#13-planner--trip-management)
14. [Planner — Booking Management](#14-planner--booking-management)
15. [Planner — Passenger List](#15-planner--passenger-list)
16. [WebSocket (Action Cable)](#15-websocket-action-cable)
17. [Seed Accounts](#16-seed-accounts)
18. [Trip Preferences (Traveler)](#18-trip-preferences-traveler)

---

## 1. Overview

| Detail           | Value                                |
|------------------|--------------------------------------|
| Framework        | Rails 8.0 (API-only)                 |
| Database         | PostgreSQL                           |
| Auth             | JWT (30-day expiry, HS256)           |
| JSON Keys        | **camelCase** (automatic transform)  |
| Pagination       | Kaminari (page-based)                |
| File Storage     | Active Storage (local / S3)          |
| Real-time        | Action Cable (WebSocket)             |
| Currency         | PKR (Pakistani Rupee)                |
| Region           | Pakistan (Northern Areas focus)      |

### Request Headers

All authenticated endpoints require:

```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

File upload endpoints use `multipart/form-data` instead.

### Response Shapes

```json
// Single resource
{ "field": "value", ... }

// Collection with pagination
{ "data": [ ... ], "meta": { "currentPage": 1, "totalPages": 3, "totalCount": 24 } }

// Error
{ "error": "message" }
```

---

## 2. Authentication

JWT tokens are obtained via `/auth/signup` or `/auth/login` and must be sent as a Bearer token in the `Authorization` header.

**Token lifetime**: 30 days

**Roles**:
- `traveler` — Can browse trips (no auth), view details (auth), book, review, and message
- `planner` — Can create/manage trips, handle bookings, view dashboard stats, manage passengers, and message

**Public endpoints** (no auth needed):
- `GET /trips` — Browse trip cards
- `GET /trips/featured` — Featured trips
- `GET /categories` — Trip categories
- `GET /collections` — Curated collections
- `GET /collections/:id` — Collection detail

**Auth-gated endpoints**:
- `GET /trips/:id` — Full trip details (planner phone, driver info, itinerary)
- All booking, review, messaging, and planner endpoints

---

## 3. Error Handling

| Status | Meaning                              | Body                                |
|--------|--------------------------------------|-------------------------------------|
| 401    | Missing or invalid JWT token         | `{ "error": "Unauthorized" }`       |
| 403    | Wrong role for this endpoint         | `{ "error": "Forbidden" }`          |
| 404    | Resource not found                   | `{ "error": "Not found" }`          |
| 422    | Validation failed                    | `{ "error": "Name can't be blank, ..." }` |

---

## 4. Endpoints Quick Reference

| #  | Method | Path                                              | Auth     | Role     |
|----|--------|---------------------------------------------------|----------|----------|
| 1  | POST   | `/auth/signup`                                     | None     | —        |
| 2  | POST   | `/auth/login`                                      | None     | —        |
| 3  | DELETE | `/auth/logout`                                     | JWT      | Any      |
| 4  | GET    | `/auth/me`                                         | JWT      | Any      |
| 5  | PATCH  | `/users/me`                                        | JWT      | Any      |
| 6  | PATCH  | `/users/me/avatar`                                 | JWT      | Any      |
| 7  | GET    | `/users/:id`                                       | JWT      | Any      |
| 8  | GET    | `/trips`                                           | **None** | —        |
| 9  | GET    | `/trips/featured`                                  | **None** | —        |
| 10 | GET    | `/trips/:id`                                       | JWT      | Any      |
| 11 | POST   | `/trips/:trip_id/bookings`                         | JWT      | Traveler |
| 12 | GET    | `/bookings`                                        | JWT      | Traveler |
| 13 | GET    | `/bookings/:id`                                    | JWT      | Any      |
| 14 | PATCH  | `/bookings/:id/cancel`                             | JWT      | Traveler |
| 15 | GET    | `/trips/:trip_id/reviews`                          | JWT      | Any      |
| 16 | POST   | `/trips/:trip_id/reviews`                          | JWT      | Traveler |
| 17 | GET    | `/conversations`                                   | JWT      | Any      |
| 18 | POST   | `/conversations`                                   | JWT      | Any      |
| 19 | GET    | `/conversations/:id/messages`                      | JWT      | Any      |
| 20 | POST   | `/conversations/:id/messages`                      | JWT      | Any      |
| 21 | PATCH  | `/conversations/:id/messages/read`                 | JWT      | Any      |
| 22 | GET    | `/categories`                                      | **None** | —        |
| 23 | GET    | `/collections`                                     | **None** | —        |
| 24 | GET    | `/collections/:id`                                 | **None** | —        |
| 25 | GET    | `/planner/stats`                                   | JWT      | Planner  |
| 26 | GET    | `/planner/trips`                                   | JWT      | Planner  |
| 27 | POST   | `/planner/trips`                                   | JWT      | Planner  |
| 28 | PATCH  | `/planner/trips/:id`                               | JWT      | Planner  |
| 29 | DELETE | `/planner/trips/:id`                               | JWT      | Planner  |
| 30 | PATCH  | `/planner/trips/:id/publish`                       | JWT      | Planner  |
| 31 | PATCH  | `/planner/trips/:id/complete`                      | JWT      | Planner  |
| 32 | POST   | `/planner/trips/:id/hero_image`                    | JWT      | Planner  |
| 33 | POST   | `/planner/trips/:id/gallery`                       | JWT      | Planner  |
| 34 | GET    | `/planner/trips/:id/passengers`                    | JWT      | Planner  |
| 35 | GET    | `/planner/bookings`                                | JWT      | Planner  |
| 36 | PATCH  | `/planner/bookings/:id/confirm`                    | JWT      | Planner  |
| 37 | PATCH  | `/planner/bookings/:id/cancel`                     | JWT      | Planner  |
| 38 | PATCH  | `/users/me/cover_photo`                            | JWT      | Any      |
| 39 | POST   | `/users/me/device_token`                           | JWT      | Any      |
| 40 | GET    | `/trip_preferences`                                | JWT      | Traveler |
| 41 | PUT    | `/trip_preferences`                                | JWT      | Traveler |

---

## 5. Auth

### POST `/auth/signup`

Register a new user account.

**Auth**: None

**Request Body** (Traveler):
```json
{
  "name": "Ahmed Khan",
  "email": "ahmed@example.com",
  "password": "securepassword",
  "role": "traveler"
}
```

**Request Body** (Planner — phone required):
```json
{
  "name": "Bilal Ahmad",
  "email": "bilal@example.com",
  "password": "securepassword",
  "role": "planner",
  "phone": "+923001234567"
}
```

| Field      | Type   | Required | Description                          |
|------------|--------|----------|--------------------------------------|
| `name`     | string | Yes      | Full name                            |
| `email`    | string | Yes      | Must be unique (case-insensitive)    |
| `password` | string | Yes      | Minimum length enforced by bcrypt    |
| `role`     | string | Yes      | `"traveler"` or `"planner"`          |
| `phone`    | string | Planner  | Required for planners only           |

**Response** `201 Created`:
```json
{
  "user": {
    "id": "1",
    "name": "Ahmed Khan",
    "email": "ahmed@example.com",
    "role": "traveler",
    "avatar": null,
    "phone": null,
    "createdAt": "2026-04-05T12:00:00Z"
  },
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

**Error** `422`:
```json
{ "error": "Email has already been taken" }
```

**Error** `422` (Planner without phone):
```json
{ "error": "Phone can't be blank" }
```

---

### POST `/auth/login`

Authenticate with email and password.

**Auth**: None

**Request Body**:
```json
{
  "email": "ahmed@example.com",
  "password": "securepassword"
}
```

**Response** `200 OK`: Same shape as signup response.

**Error** `401`:
```json
{ "error": "Invalid email or password" }
```

---

### DELETE `/auth/logout`

Logout (stateless — client should discard the token).

**Auth**: JWT

**Response**: `204 No Content`

---

### GET `/auth/me`

Get the current authenticated user's profile.

**Auth**: JWT

**Response** `200 OK` (Traveler):
```json
{
  "id": "1",
  "name": "Ahmed Khan",
  "email": "ahmed@example.com",
  "role": "traveler",
  "avatar": null,
  "phone": null,
  "notificationsEnabled": true,
  "createdAt": "2026-04-05T12:00:00Z"
}
```

**Response** `200 OK` (Planner — includes extra fields):
```json
{
  "id": "2",
  "name": "Bilal Ahmad",
  "email": "bilal@nazary.pk",
  "role": "planner",
  "avatar": "https://...",
  "phone": "+923001234567",
  "notificationsEnabled": true,
  "createdAt": "2026-04-05T12:00:00Z",
  "bio": "Professional tour guide specializing in Northern Pakistan...",
  "guild": "Karakoram Explorers",
  "rating": 4.9,
  "tripsHosted": 34,
  "totalReviews": 89,
  "youtubeUrl": null,
  "instagramUrl": "https://instagram.com/karakoram_explorers",
  "tiktokUrl": null,
  "twitterUrl": null,
  "websiteUrl": "https://karakoramexplorers.pk",
  "coverPhoto": "https://..."
}
```

---

## 6. User Profile

### PATCH `/users/me`

Update the current user's profile.

**Auth**: JWT

**Request Body** (all fields optional):
```json
{
  "name": "New Name",
  "phone": "+923009876543",
  "bio": "Updated bio",
  "guild": "Explorer Guild"
}
```

| Field   | Type   | Required | Description                     |
|---------|--------|----------|---------------------------------|
| `name`  | string | No | Full name                       |
| `phone` | string | No | Phone number                    |
| `bio`   | string | No | Bio (mainly for planners)       |
| `guild` | string | No | Guild name (mainly for planners)|
| `notifications_enabled` | boolean | No | Enable/disable push notifications (default: true) |
| `youtube_url`   | string | No | YouTube channel URL (planners) |
| `instagram_url` | string | No | Instagram profile URL (planners) |
| `tiktok_url`    | string | No | TikTok profile URL (planners) |
| `twitter_url`   | string | No | Twitter/X profile URL (planners) |
| `website_url`   | string | No | Website URL (planners) |

**Response** `200 OK`: UserSerializer (same as `/auth/me`)

---

### PATCH `/users/me/avatar`

Upload or replace the user's avatar image.

**Auth**: JWT

**Request**: `multipart/form-data`

| Field    | Type | Required | Description        |
|----------|------|----------|--------------------|
| `avatar` | file | Yes      | Image file (JPG, PNG, etc.) |

**Response** `200 OK`: UserSerializer

**Error** `422`:
```json
{ "error": "Avatar file is required" }
```

---

### PATCH `/users/me/cover_photo`

Upload or replace the user's cover photo (planners).

**Auth**: JWT

**Request**: `multipart/form-data`

| Field         | Type | Required | Description              |
|---------------|------|----------|--------------------------|
| `cover_photo` | file | Yes      | Image file (JPG, PNG, etc.) |

**Response** `200 OK`: UserSerializer

**Error** `422`:
```json
{ "error": "Cover photo file is required" }
```

---

### GET `/users/:id`

Get a user's public profile.

**Auth**: JWT

**URL Params**:
| Param | Type   | Description |
|-------|--------|-------------|
| `id`  | string | User ID     |

**Response** `200 OK`: UserSerializer

---

## 7. Trips (Browse)

> **Key rule**: Browsing trip cards does NOT require login.
> Seeing full trip details (description, itinerary, planner phone, driver info) DOES require login.

### GET `/trips`

Browse and search active trips with filtering, sorting, and pagination.

**Auth**: **None** (public)

**Query Params**:

| Param       | Type   | Default  | Description                                    |
|-------------|--------|----------|------------------------------------------------|
| `q`         | string | —        | Full-text search (title, location, description)|
| `tag`       | string | —        | Filter by tag (e.g. `"Trekking"`)              |
| `location`  | string | —        | Filter by location (e.g. `"Hunza"`)            |
| `min_price` | number | —        | Minimum price filter (PKR)                     |
| `max_price` | number | —        | Maximum price filter (PKR)                     |
| `sort`      | string | `newest` | `price_asc`, `price_desc`, `rating`, `newest`  |
| `page`      | int    | 1        | Page number                                    |
| `per_page`  | int    | 10       | Items per page (max 50)                        |

**Response** `200 OK`:
```json
{
  "data": [
    {
      "id": "1",
      "title": "Kashmir Valley Explorer",
      "location": "Neelum Valley, AJK",
      "heroImage": "https://...",
      "price": 45000,
      "currency": "PKR",
      "duration": "5 days",
      "dates": "Oct 12 - 16",
      "seatsLeft": 4,
      "totalSeats": 12,
      "tags": ["Northern Areas", "Trekking"],
      "rating": 4.9,
      "reviewCount": 47,
      "host": {
        "id": "2",
        "name": "Bilal A.",
        "avatar": "https://..."
      }
    }
  ],
  "meta": {
    "currentPage": 1,
    "totalPages": 3,
    "totalCount": 24
  }
}
```

> **Note**: Only trips with `status: "active"` are returned.
> Trip list does NOT expose `host.phone`, `host.guild`, `host.rating`, driver info, description, itinerary, or highlights. Only card-preview data.

---

### GET `/trips/featured`

Get featured trips for the home screen (max 10, newest active trips).

**Auth**: **None** (public)

**Response** `200 OK`: Array of trip objects (same shape as trips index, without pagination meta).

---

### GET `/trips/:id`

Get full trip details including itinerary, gallery, highlights, planner phone, and driver info.

**Auth**: JWT (**required** — forces login to see details)

**Response** `200 OK`:
```json
{
  "id": "1",
  "title": "Kashmir Valley Explorer",
  "subtitle": "A Journey Through Paradise on Earth",
  "description": "Embark on a 5-day guided expedition through the stunning Neelum Valley...",
  "location": "Neelum Valley, AJK",
  "heroImage": "https://...",
  "gallery": ["https://...", "https://..."],
  "price": 45000,
  "currency": "PKR",
  "duration": "5 days",
  "dates": "Oct 12 - 16",
  "totalSeats": 12,
  "seatsLeft": 4,
  "status": "active",
  "tags": ["Northern Areas", "Trekking"],
  "rating": 4.9,
  "reviewCount": 47,
  "highlights": [
    "Visit Sharda Temple ruins",
    "Trek to Ratti Gali Lake"
  ],
  "itinerary": [
    { "day": "1", "title": "Arrival in Muzaffarabad", "desc": "Welcome dinner & expedition briefing" },
    { "day": "2", "title": "Neelum Valley Drive", "desc": "Scenic drive through Keran, Sharda" }
  ],
  "createdAt": "2026-03-01T00:00:00Z",
  "host": {
    "id": "2",
    "name": "Bilal Ahmad",
    "avatar": "https://...",
    "phone": "+923001234567",
    "guild": "Karakoram Explorers",
    "rating": 4.9
  },
  "driver": {
    "name": "Farooq Khan",
    "phone": "+923451234567",
    "vehicle": "Toyota Coaster - White (MZD-4521)"
  }
}
```

**Error** `401` (not logged in):
```json
{ "error": "Login required to view trip details" }
```

> **Why auth-gated?** This forces travelers to sign up before they can see the planner's phone number, driver details, and full trip information — driving user registration.

---

## 8. Bookings (Traveler)

### POST `/trips/:trip_id/bookings`

Request to join a trip (traveler only). Amount is auto-calculated as `price * seats`.

**Auth**: JWT (Traveler)

**URL Params**:
| Param     | Type   | Description |
|-----------|--------|-------------|
| `trip_id` | string | Trip ID     |

**Request Body**:
```json
{
  "seats": 2,
  "note": "Joining with my brother. Any dietary options?"
}
```

| Field   | Type    | Required | Default | Description                         |
|---------|---------|----------|---------|-------------------------------------|
| `seats` | integer | No       | 1       | Number of seats to book             |
| `note`  | string  | No       | null    | Message to planner                  |

**Response** `201 Created`:
```json
{
  "id": "1",
  "tripId": "1",
  "travelerId": "5",
  "travelerName": "Ahmed Khan",
  "travelerAvatar": "https://...",
  "status": "pending",
  "seats": 2,
  "amount": 90000,
  "note": "Joining with my brother. Any dietary options?",
  "createdAt": "2026-04-05T14:00:00Z"
}
```

**Constraints**:
- Only travelers can book (planners get `403`)
- One booking per traveler per trip (duplicate gets `422`)
- Trip must have enough `seats_left` (otherwise `422`)
- Trip must be `active`

---

### GET `/bookings`

Get the current traveler's bookings.

**Auth**: JWT (Traveler)

**Query Params**:
| Param      | Type | Default | Description      |
|------------|------|---------|------------------|
| `page`     | int  | 1       | Page number      |
| `per_page` | int  | 10      | Items per page   |

**Response** `200 OK`:
```json
{
  "data": [
    {
      "id": "1",
      "tripId": "1",
      "travelerId": "5",
      "travelerName": "Ahmed Khan",
      "travelerAvatar": null,
      "status": "confirmed",
      "seats": 2,
      "amount": 90000,
      "note": "Joining with my friend.",
      "createdAt": "2026-04-05T12:00:00Z"
    }
  ],
  "meta": { "currentPage": 1, "totalPages": 1, "totalCount": 1 }
}
```

---

### GET `/bookings/:id`

Get a single booking's details.

**Auth**: JWT

**Response** `200 OK`: BookingSerializer object.

---

### PATCH `/bookings/:id/cancel`

Cancel one of your bookings (traveler only).

**Auth**: JWT (Traveler)

**Response** `200 OK`: BookingSerializer with `status: "cancelled"`.

---

## 9. Reviews

### GET `/trips/:trip_id/reviews`

List reviews for a specific trip.

**Auth**: JWT

**Query Params**:
| Param      | Type | Default | Description      |
|------------|------|---------|------------------|
| `page`     | int  | 1       | Page number      |
| `per_page` | int  | 10      | Items per page   |

**Response** `200 OK`:
```json
{
  "data": [
    {
      "id": "1",
      "tripId": "1",
      "userId": "5",
      "name": "Ahmed K.",
      "avatar": "https://...",
      "rating": 5,
      "text": "Best trip I've ever been on! Bilal bhai is an amazing guide...",
      "date": "Apr 2026"
    }
  ],
  "meta": { "currentPage": 1, "totalPages": 1, "totalCount": 1 }
}
```

---

### POST `/trips/:trip_id/reviews`

Write a review for a trip (traveler only, must have confirmed booking).

**Auth**: JWT (Traveler)

**Request Body**:
```json
{
  "rating": 5,
  "text": "Absolutely amazing experience! The Kashmir valley was breathtaking..."
}
```

| Field    | Type    | Required | Description          |
|----------|---------|----------|----------------------|
| `rating` | integer | Yes      | 1 to 5               |
| `text`   | string  | Yes      | Review body text      |

**Response** `201 Created`: ReviewSerializer object.

**Constraints**:
- One review per traveler per trip
- Rating must be 1–5
- Traveler must have a confirmed booking

---

## 10. Conversations & Messages

### GET `/conversations`

List all conversations for the current user.

**Auth**: JWT

**Response** `200 OK`:
```json
[
  {
    "id": "1",
    "participantId": "3",
    "participantName": "Bilal Ahmad",
    "participantAvatar": "https://...",
    "lastMessage": "Wa Alaikum Assalam! Moderate hai, 3-4 hours ka trek.",
    "time": "2m ago",
    "unread": 2,
    "online": true,
    "tripContext": "Kashmir Valley Explorer"
  }
]
```

> `participantId/Name/Avatar` = the **other** user (not the current user).
> `time` = relative time string computed server-side.

---

### POST `/conversations`

Start a new conversation (or return existing one between same users).

**Auth**: JWT

**Request Body**:
```json
{
  "participant_id": "3",
  "trip_id": "2",
  "message": "Assalam o Alaikum! I had a question about the Swat trip..."
}
```

| Field            | Type   | Required | Description                          |
|------------------|--------|----------|--------------------------------------|
| `participant_id` | string | Yes      | Other user's ID                      |
| `trip_id`        | string | No       | Optional trip context                |
| `message`        | string | No       | Optional first message               |

**Response** `201 Created`: ConversationSerializer object.

---

### GET `/conversations/:id/messages`

Get message history for a conversation (newest first for infinite scroll).

**Auth**: JWT

**Query Params**:
| Param      | Type | Default | Description      |
|------------|------|---------|------------------|
| `page`     | int  | 1       | Page number      |
| `per_page` | int  | 10      | Items per page   |

**Response** `200 OK`:
```json
{
  "data": [
    {
      "id": "1",
      "conversationId": "1",
      "senderId": "3",
      "text": "Wa Alaikum Assalam! Moderate hai, comfortable shoes lana zaroor.",
      "createdAt": "2026-04-05T14:00:00Z",
      "read": true
    }
  ],
  "meta": { "currentPage": 1, "totalPages": 5, "totalCount": 48 }
}
```

---

### POST `/conversations/:id/messages`

Send a message in a conversation.

**Auth**: JWT

**Request Body**:
```json
{
  "text": "Shukriya! Main shoes le aaunga."
}
```

**Response** `201 Created`: MessageSerializer object.

> Messages are also **broadcast via Action Cable** in real-time.

---

### PATCH `/conversations/:id/messages/read`

Mark all unread messages from other users as read.

**Auth**: JWT

**Response**: `204 No Content`

---

## 11. Categories & Collections

### GET `/categories`

List all trip categories.

**Auth**: **None** (public)

**Response** `200 OK`:
```json
{
  "data": [
    { "id": "1", "label": "All", "icon": "compass" },
    { "id": "2", "label": "Northern Areas", "icon": "mountain-snow" },
    { "id": "3", "label": "Trekking", "icon": "footsteps" },
    { "id": "4", "label": "Family", "icon": "people" },
    { "id": "5", "label": "Cultural", "icon": "landmark" },
    { "id": "6", "label": "Camping", "icon": "bonfire" }
  ]
}
```

---

### GET `/collections`

List curated trip collections.

**Auth**: **None** (public)

**Response** `200 OK`:
```json
{
  "data": [
    {
      "id": "1",
      "title": "Northern Wonders",
      "subtitle": "12 curated trips",
      "image": "https://..."
    },
    {
      "id": "2",
      "title": "Kashmir & Beyond",
      "subtitle": "8 curated trips",
      "image": "https://..."
    },
    {
      "id": "3",
      "title": "Weekend Getaways",
      "subtitle": "15 trips near Islamabad",
      "image": "https://..."
    }
  ]
}
```

---

### GET `/collections/:id`

Get a collection with its trips.

**Auth**: **None** (public)

**Response** `200 OK`:
```json
{
  "id": "1",
  "title": "Northern Wonders",
  "subtitle": "12 curated trips",
  "image": "https://...",
  "trips": [
    { "...TripListSerializer fields..." }
  ]
}
```

---

## 12. Planner — Dashboard Stats

### GET `/planner/stats`

Get aggregated dashboard metrics for the current planner.

**Auth**: JWT (Planner)

**Response** `200 OK`:
```json
{
  "totalRevenue": 1245000,
  "activeTrips": 8,
  "totalBookings": 47,
  "totalTravelers": 38,
  "avgRating": 4.9,
  "monthlyGrowth": 23
}
```

| Field            | Type    | Description                                        |
|------------------|---------|----------------------------------------------------|
| `totalRevenue`   | decimal | Sum of all confirmed booking amounts (PKR)         |
| `activeTrips`    | integer | Number of trips with `status: "active"`            |
| `totalBookings`  | integer | Count of confirmed bookings                        |
| `totalTravelers` | integer | Distinct travelers with confirmed bookings         |
| `avgRating`      | float   | Average rating across all planner's trips          |
| `monthlyGrowth`  | integer | Revenue growth percentage vs last month            |

---

## 13. Planner — Trip Management

### GET `/planner/trips`

List all trips belonging to the current planner (all statuses).

**Auth**: JWT (Planner)

**Query Params**:
| Param      | Type | Default | Description      |
|------------|------|---------|------------------|
| `page`     | int  | 1       | Page number      |
| `per_page` | int  | 10      | Items per page   |

**Response** `200 OK`: Paginated array of TripListSerializer objects.

---

### POST `/planner/trips`

Create a new trip (created as `draft` by default).

**Auth**: JWT (Planner)

**Request Body**:
```json
{
  "title": "Kumrat Valley Adventure",
  "subtitle": "Hidden gem of KPK",
  "description": "A 4-day adventure through Kumrat Valley...",
  "location": "Kumrat Valley, Dir Upper, KPK",
  "price": 35000,
  "currency": "PKR",
  "duration": "4 days",
  "start_date": "2026-06-15",
  "end_date": "2026-06-18",
  "total_seats": 15,
  "tags": ["Camping", "Trekking"],
  "highlights": ["Jahaz Banda meadows", "Do Kala Chashma waterfall"],
  "driver_name": "Shahid Gul",
  "driver_phone": "+923451234567",
  "driver_vehicle": "Toyota Coaster - White (DIR-1234)",
  "itinerary_days": [
    { "day": 1, "title": "Departure from Islamabad", "desc": "Early morning departure" },
    { "day": 2, "title": "Kumrat Valley", "desc": "Explore Jahaz Banda" }
  ]
}
```

| Field             | Type     | Required | Description                               |
|-------------------|----------|----------|-------------------------------------------|
| `title`           | string   | Yes      | Trip title                                |
| `subtitle`        | string   | No       | Short subtitle                            |
| `description`     | string   | Yes      | Full description                          |
| `location`        | string   | Yes      | Location name                             |
| `price`           | decimal  | Yes      | Price per person (PKR)                    |
| `currency`        | string   | No       | Default: `"PKR"`                          |
| `duration`        | string   | Yes      | e.g. `"4 days"`                           |
| `start_date`      | date     | Yes      | Format: `YYYY-MM-DD`                      |
| `end_date`        | date     | Yes      | Format: `YYYY-MM-DD`                      |
| `total_seats`     | integer  | Yes      | Total capacity                            |
| `tags`            | string[] | No       | Array of tag strings                      |
| `highlights`      | string[] | No       | Array of highlight strings                |
| `driver_name`     | string   | No       | Driver's name                             |
| `driver_phone`    | string   | No       | Driver's phone number                     |
| `driver_vehicle`  | string   | No       | Vehicle description (model, color, plate) |
| `itinerary_days`  | array    | No       | Array of `{ day, title, desc }` objects   |

**Response** `201 Created`: TripDetailSerializer object.

---

### PATCH `/planner/trips/:id`

Update an existing trip.

**Auth**: JWT (Planner)

**Request Body**: Same fields as create (all optional). If `itinerary_days` is provided, existing days are replaced entirely.

**Response** `200 OK`: TripDetailSerializer object.

> **Ownership**: Planners can only update their own trips.

---

### DELETE `/planner/trips/:id`

Delete a trip (draft only).

**Auth**: JWT (Planner)

**Response**: `204 No Content`

**Error** `422`:
```json
{ "error": "Only draft trips can be deleted" }
```

---

### PATCH `/planner/trips/:id/publish`

Transition a trip from `draft` to `active`.

**Auth**: JWT (Planner)

**Response** `200 OK`: TripDetailSerializer with `status: "active"`.

**Error** `422`:
```json
{ "error": "Only draft trips can be published" }
```

> **Side effect**: Publishing a trip enqueues `NotifyNewTripJob` which sends push notifications to all travelers. Travelers with matching trip preferences receive a "Matches your preferences!" notification; others receive a "New Trip Available!" notification.

---

### PATCH `/planner/trips/:id/complete`

Transition a trip from `active` to `completed`.

**Auth**: JWT (Planner)

**Response** `200 OK`: TripDetailSerializer with `status: "completed"`.

**Error** `422`:
```json
{ "error": "Only active trips can be completed" }
```

---

### POST `/planner/trips/:id/hero_image`

Upload or replace the trip's hero image.

**Auth**: JWT (Planner)

**Request**: `multipart/form-data`

| Field        | Type | Required | Description       |
|--------------|------|----------|-------------------|
| `hero_image` | file | Yes      | Image file        |

**Response** `200 OK`: TripDetailSerializer object.

---

### POST `/planner/trips/:id/gallery`

Add images to the trip's gallery.

**Auth**: JWT (Planner)

**Request**: `multipart/form-data`

| Field     | Type   | Required | Description                  |
|-----------|--------|----------|------------------------------|
| `gallery` | file[] | Yes      | One or more image files      |

**Response** `200 OK`: TripDetailSerializer object.

> Gallery images are **appended** (not replaced).

---

## 14. Planner — Booking Management

### GET `/planner/bookings`

List all bookings for the planner's trips.

**Auth**: JWT (Planner)

**Query Params**:
| Param      | Type   | Default | Description                              |
|------------|--------|---------|------------------------------------------|
| `status`   | string | —       | Filter: `pending`, `confirmed`, `cancelled` |
| `trip_id`  | string | —       | Filter by specific trip                  |
| `page`     | int    | 1       | Page number                              |
| `per_page` | int    | 10      | Items per page                           |

**Response** `200 OK`:
```json
{
  "data": [
    {
      "id": "1",
      "tripId": "1",
      "travelerId": "5",
      "travelerName": "Ahmed Khan",
      "travelerAvatar": "https://...",
      "travelerPhone": "+923331234567",
      "tripTitle": "Kashmir Valley Explorer",
      "status": "pending",
      "seats": 2,
      "amount": 90000,
      "note": "Joining with my brother",
      "createdAt": "2026-04-05T12:00:00Z"
    }
  ],
  "meta": { "currentPage": 1, "totalPages": 1, "totalCount": 1 }
}
```

> **Note**: Planner booking responses include `tripTitle` and `travelerPhone` fields.

---

### Booking Flow

```
Traveler taps "Request to Join" on trip
        ↓
POST /trips/:id/bookings (status: pending, seats: N)
        ↓
Planner sees request in BookingRequestsScreen
        ↓
Planner taps "Confirm" → PATCH /planner/bookings/:id/confirm
        ↓
status → confirmed, seats_left decreases, traveler appears in passengers list
```

### PATCH `/planner/bookings/:id/confirm`

Confirm a pending booking.

**Auth**: JWT (Planner)

**Response** `200 OK`: BookingSerializer with `status: "confirmed"`, `tripTitle`, and `travelerPhone`.

**Error** `422`:
```json
{ "error": "Not enough seats left" }
```

---

### PATCH `/planner/bookings/:id/cancel`

Cancel/reject a booking.

**Auth**: JWT (Planner)

**Response** `200 OK`: BookingSerializer with `status: "cancelled"`, `tripTitle`, and `travelerPhone`.

---

## 15. Planner — Passenger List

### GET `/planner/trips/:id/passengers`

Get the list of travelers with confirmed/pending bookings for a specific trip. Planner uses this to manage the passenger manifest.

**Auth**: JWT (Planner, trip owner only)

**Response** `200 OK`:
```json
{
  "data": [
    {
      "id": "1",
      "bookingId": "5",
      "name": "Ahmed Khan",
      "email": "ahmed@example.com",
      "phone": "+923331234567",
      "avatar": "https://...",
      "seats": 2,
      "amount": 90000,
      "status": "confirmed",
      "bookedAt": "2026-04-01T10:00:00Z"
    },
    {
      "id": "3",
      "bookingId": "7",
      "name": "Fatima Ali",
      "email": "fatima@example.com",
      "phone": null,
      "avatar": "https://...",
      "seats": 1,
      "amount": 45000,
      "status": "confirmed",
      "bookedAt": "2026-04-02T14:30:00Z"
    }
  ],
  "meta": {
    "totalSeats": 12,
    "seatsBooked": 3,
    "seatsLeft": 9,
    "totalRevenue": 135000
  }
}
```

| Meta Field      | Type    | Description                            |
|-----------------|---------|----------------------------------------|
| `totalSeats`    | integer | Trip's total seat capacity             |
| `seatsBooked`   | integer | Sum of confirmed booking seats         |
| `seatsLeft`     | integer | Remaining available seats              |
| `totalRevenue`  | decimal | Sum of confirmed booking amounts (PKR) |

---

## 16. WebSocket (Action Cable)

### Connection

```
ws://localhost:3000/cable?token=<jwt_token>
```

Authentication is handled via the `token` query parameter.

### ConversationChannel

**Subscribe**:
```json
{
  "command": "subscribe",
  "identifier": "{\"channel\":\"ConversationChannel\",\"id\":\"1\"}"
}
```

Only participants of the conversation can subscribe (others are rejected).

**Broadcast Shape** (sent when a new message is created):
```json
{
  "id": "42",
  "conversationId": "1",
  "senderId": "3",
  "text": "Islamabad se kitne baje nikalna hai?",
  "createdAt": "2026-04-05T14:30:00Z",
  "read": false
}
```

---

## 17. Seed Accounts

The following accounts are available after running `rails db:seed`:

| Role     | Email                | Password      | Phone           |
|----------|----------------------|---------------|-----------------|
| Planner  | `bilal@nazary.pk`    | `password123` | +923001234567   |
| Planner  | `ayesha@nazary.pk`   | `password123` | +923009876543   |
| Traveler | `ahmed@example.com`  | `password123` | —               |
| Traveler | `fatima@example.com` | `password123` | +923331234567   |

### Seed Data Includes

- 6 categories (All, Northern Areas, Trekking, Family, Cultural, Camping)
- 4 trips:
  - "Kashmir Valley Explorer" (active, Neelum Valley, PKR 45,000)
  - "Swat & Kalam Escape" (active, Swat/Kalam, PKR 35,000)
  - "Kumrat Valley Adventure" (active, Dir Upper, PKR 32,000)
  - "Hunza & Fairy Meadows" (draft, Hunza/GB, PKR 75,000)
- 3 bookings (2 confirmed on Kashmir trip, 1 pending on Swat trip)
- 2 reviews (5 stars each on Kashmir trip)
- 2 conversations with Urdu messages
- 3 collections (Northern Wonders, Kashmir & Beyond, Weekend Getaways)
- Driver details on all active trips

---

## 18. Trip Preferences (Traveler)

### GET `/trip_preferences`

Get the current traveler's trip preferences for smart trip matching notifications.

**Auth**: JWT

**Response** `200 OK` (preferences exist):
```json
{
  "id": "1",
  "budgetMin": 5000,
  "budgetMax": 50000,
  "preferredMonths": [6, 7, 8, 10],
  "followedAgencyId": "3",
  "followedAgencyName": "Karakoram Explorers"
}
```

**Response** `200 OK` (no preferences yet):
```json
{ "data": null }
```

---

### PUT `/trip_preferences`

Create or update trip preferences (upsert). Used for smart trip matching — when a new trip is published, travelers with matching preferences receive a "Matches your preferences!" notification.

**Auth**: JWT

**Request Body** (all fields optional):
```json
{
  "budget_min": 5000,
  "budget_max": 50000,
  "preferred_months": [6, 7, 8, 10],
  "followed_agency_id": "3"
}
```

| Field                | Type      | Required | Description                                          |
|----------------------|-----------|----------|------------------------------------------------------|
| `budget_min`         | decimal   | No       | Minimum budget (PKR)                                 |
| `budget_max`         | decimal   | No       | Maximum budget (must be > budget_min)                |
| `preferred_months`   | integer[] | No       | Array of month numbers (1=Jan, 12=Dec)               |
| `followed_agency_id` | string    | No       | Agency (planner) user ID to follow — must be planner |

**Response** `200 OK`: TripPreferenceSerializer

**Error** `422`:
```json
{ "error": "Budget max must be greater than budget min" }
```

---

## Appendix: Screen Mapping

| Screen                   | Endpoints                                                           | Auth Required |
|--------------------------|---------------------------------------------------------------------|---------------|
| **SettingsScreen**       | `PATCH /users/me`, `GET /trip_preferences`, `PUT /trip_preferences` | Yes           |

---

## Appendix: Enum Values

### User Role
| Value | Integer |
|-------|---------|
| `traveler` | 0 |
| `planner`  | 1 |

### Trip Status
| Value       | Integer | Description              |
|-------------|---------|--------------------------|
| `draft`     | 0       | Not yet published        |
| `active`    | 1       | Visible and bookable     |
| `completed` | 2       | Trip has concluded       |
| `cancelled` | 3       | Trip was cancelled       |

**Transitions**: `draft` → `active` → `completed` (or `cancelled` at any stage)

### Booking Status
| Value       | Integer | Description                    |
|-------------|---------|--------------------------------|
| `pending`   | 0       | Awaiting planner confirmation  |
| `confirmed` | 1       | Booking confirmed              |
| `cancelled` | 2       | Cancelled by traveler/planner  |

### Notification Type
| Value               | Integer | Description                               |
|---------------------|---------|-------------------------------------------|
| `new_trip`          | 7       | New trip published notification           |
| `preference_match`  | 8       | Trip matches traveler preferences         |

---

## Appendix: Data Access Rules

| Data                           | Who Can See                           |
|--------------------------------|---------------------------------------|
| Trip cards (title, price, pic) | Everyone (no login needed)            |
| Trip details + itinerary       | Logged-in users only                  |
| Trip planner phone number      | Logged-in users only (in trip detail) |
| Driver details                 | Logged-in users only (in trip detail) |
| Passenger list                 | Trip planner (owner) only             |
| Booking requests               | Trip planner (owner) only             |
| Traveler's own bookings        | That traveler only                    |
| Chat messages                  | Conversation participants only        |

---

## Appendix: File Structure

```
app/
  controllers/
    api/v1/
      base_controller.rb
      auth_controller.rb
      users_controller.rb
      trips_controller.rb
      bookings_controller.rb
      reviews_controller.rb
      conversations_controller.rb
      messages_controller.rb
      categories_controller.rb
      collections_controller.rb
      trip_preferences_controller.rb
      planner/
        base_controller.rb
        stats_controller.rb
        trips_controller.rb
        bookings_controller.rb
    concerns/
      authenticatable.rb
      authorizable.rb
      paginatable.rb
  models/
    user.rb
    trip.rb
    itinerary_day.rb
    booking.rb
    review.rb
    conversation.rb
    conversation_participant.rb
    message.rb
    category.rb
    collection.rb
    collection_trip.rb
    trip_preference.rb
  serializers/
    user_serializer.rb
    trip_list_serializer.rb
    trip_detail_serializer.rb
    booking_serializer.rb
    passenger_serializer.rb
    review_serializer.rb
    conversation_serializer.rb
    message_serializer.rb
    trip_preference_serializer.rb
  services/
    jwt_service.rb
    notification_service.rb
    expo_push_service.rb
  jobs/
    notify_new_trip_job.rb
    trip_reminder_job.rb
  channels/
    application_cable/
      connection.rb
      channel.rb
    conversation_channel.rb
config/
  routes.rb
  initializers/
    cors.rb
    active_model_serializers.rb
```
