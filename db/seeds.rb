puts "Seeding Nazary..."

# ─── Cleanup ──────────────────────────────────────────────
# Reset everything for a clean seed
[ArrangementRequest, CollectionTrip, Collection, BikeProfile, PlaceReview, Place,
 Notification, PlannerReview, TripRequest, Review, Booking, ItineraryDay, TripUpdate, Trip,
 CoupleRequest, OtpVerification, Category, User].each do |model|
  model.destroy_all
rescue StandardError
  nil
end
ActiveStorage::Attachment.destroy_all rescue nil

puts "  Cleaned existing data"

# ─── Categories ───────────────────────────────────────────
categories = ["All", "Adventure", "Cultural", "Wellness", "Family", "Bike"]
icons = ["compass", "mountain-snow", "landmark", "heart-pulse", "people", "bike"]
categories.each_with_index do |label, i|
  Category.create!(label: label, icon: icons[i])
end
puts "  Created #{Category.count} categories"

# ─── Planner 1: Usman Malik ──────────────────────────────
planner = User.create!(
  name: "Usman Malik",
  email: "usman@nazary.com",
  password: "password123",
  role: :planner,
  bio: "Born and raised in Gilgit. Leading expeditions across Karakoram and Hindukush for 10 years. Every trail has a story.",
  guild: "Karakoram Explorers",
  agency_name: "Malik Adventures",
  agency_tagline: "Your gateway to the mountains",
  years_experience: 10,
  phone: "+923001234567",
  phone_verified: true,
  profile_completed: true,
  premium: true,
  verified: true
)

# ─── Planner 2: Ayesha Baig ──────────────────────────────
planner2 = User.create!(
  name: "Ayesha Baig",
  email: "ayesha@nazary.com",
  password: "password123",
  role: :planner,
  bio: "Passionate about responsible tourism in Pakistan. Specializing in family-friendly and cultural tours of the northern areas.",
  guild: "Northern Sisters",
  agency_name: "Baig Travels",
  agency_tagline: "Discover the undiscovered",
  years_experience: 7,
  phone: "+923009876543",
  phone_verified: true,
  profile_completed: true,
  premium: true,
  verified: true
)

# ─── Planner 3: Haider Shah ──────────────────────────────
planner3 = User.create!(
  name: "Haider Shah",
  email: "haider@nazary.com",
  password: "password123",
  role: :planner,
  bio: "Motorcycle touring specialist. Ridden every pass in northern Pakistan. If it has two wheels and a mountain road, I'm in.",
  guild: "KKH Riders",
  agency_name: "Shah Bike Tours",
  agency_tagline: "Ride the roof of the world",
  years_experience: 5,
  phone: "+923331112233",
  phone_verified: true,
  profile_completed: true,
  premium: true,
  verified: true
)

puts "  Created 3 planners"

# ─── Traveler 1: Zainab Hussain ──────────────────────────
traveler = User.create!(
  name: "Zainab Hussain",
  email: "zainab@nazary.com",
  password: "password123",
  role: :traveler,
  phone: "+923005551234",
  phone_verified: true,
  profile_completed: true,
  premium: true
)

# ─── Traveler 2: Bilal Ahmed ─────────────────────────────
traveler2 = User.create!(
  name: "Bilal Ahmed",
  email: "bilal@nazary.com",
  password: "password123",
  role: :traveler,
  phone: "+923007778899",
  phone_verified: true,
  profile_completed: true
)

# ─── Traveler 3: Mehreen Khan ────────────────────────────
traveler3 = User.create!(
  name: "Mehreen Khan",
  email: "mehreen@nazary.com",
  password: "password123",
  role: :traveler,
  phone: "+923214567890",
  phone_verified: true,
  profile_completed: true
)

puts "  Created 3 travelers"

# ─── Helper: Attach image from URL ───────────────────────
def attach_image(record, attachment_name, url, filename)
  require "open-uri"
  file = URI.parse(url).open
  record.send(attachment_name).attach(
    io: file,
    filename: filename,
    content_type: "image/jpeg"
  )
  puts "    Attached #{filename}"
rescue StandardError => e
  puts "    [SKIP] Could not attach #{filename}: #{e.message}"
end

# ─── Planner Avatars ──────────────────────────────────────
attach_image(planner, :avatar, "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80", "usman_avatar.jpg")
attach_image(planner2, :avatar, "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80", "ayesha_avatar.jpg")
attach_image(planner3, :avatar, "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&q=80", "haider_avatar.jpg")

# ─── Traveler Avatars ─────────────────────────────────────
attach_image(traveler, :avatar, "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&q=80", "zainab_avatar.jpg")
attach_image(traveler2, :avatar, "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&q=80", "bilal_avatar.jpg")
attach_image(traveler3, :avatar, "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80", "mehreen_avatar.jpg")

# ═══════════════════════════════════════════════════════════
#  TRIPS
# ═══════════════════════════════════════════════════════════

# ─── Trip 1: Hunza Valley Explorer ────────────────────────
trip1 = Trip.create!(
  host: planner,
  title: "Hunza Valley Explorer",
  subtitle: "The Crown Jewel of Gilgit-Baltistan",
  description: "Experience the magic of Hunza Valley — from the ancient Baltit Fort to the turquoise waters of Attabad Lake. This 6-day journey covers Karimabad, Eagle's Nest, Passu Cones, and local Hunzai cuisine. Perfect for first-time visitors to the north.",
  location: "Hunza Valley, Gilgit-Baltistan",
  price: 45000,
  currency: "PKR",
  duration: "6 days",
  start_date: "2026-06-15",
  end_date: "2026-06-20",
  total_seats: 15,
  status: :active,
  trip_type: :casual,
  tags: ["Adventure", "Cultural", "Mountain"],
  highlights: [
    "Visit the 700-year-old Baltit Fort",
    "Sunrise at Eagle's Nest viewpoint",
    "Boating on turquoise Attabad Lake",
    "Walk across Passu Suspension Bridge",
    "Traditional Hunzai apricot feast",
    "Photography at Passu Cones"
  ]
)
attach_image(trip1, :hero_image, "https://images.unsplash.com/photo-1586348943529-beaae6c28db9?w=800&q=80", "hunza_hero.jpg")

[
  [1, "Islamabad to Karimabad", "Fly to Gilgit, drive to Karimabad. Evening walk through the old bazaar."],
  [2, "Baltit & Altit Forts", "Explore both heritage forts. Lunch at a local home. Sunset at Eagle's Nest."],
  [3, "Attabad Lake Day", "Full day at Attabad Lake — boating, jet ski, lakeside lunch."],
  [4, "Passu & Borith Lake", "Trek to Passu Glacier viewpoint. Cross the suspension bridge. Visit Borith Lake."],
  [5, "Nagar Valley & Hopar", "Drive to Hopar Glacier. Visit Nagar village. Local cooking class."],
  [6, "Departure", "Morning free time for shopping. Drive to Gilgit. Fly back to Islamabad."]
].each { |day, title, desc| trip1.itinerary_days.create!(day: day, title: title, desc: desc) }

# ─── Trip 2: Fairy Meadows & Nanga Parbat ─────────────────
trip2 = Trip.create!(
  host: planner2,
  title: "Fairy Meadows Trek",
  subtitle: "Camp at the Foot of the Killer Mountain",
  description: "Trek through pine forests to the legendary Fairy Meadows — a lush green plateau with jaw-dropping views of Nanga Parbat (8,126m). This trip is for those who want to disconnect from the world and reconnect with nature.",
  location: "Fairy Meadows, Diamer",
  price: 35000,
  currency: "PKR",
  duration: "5 days",
  start_date: "2026-07-01",
  end_date: "2026-07-05",
  total_seats: 10,
  status: :active,
  trip_type: :casual,
  tags: ["Trekking", "Camping", "Mountain"],
  highlights: [
    "Trek through dense pine forests",
    "Camp with Nanga Parbat views",
    "Visit Beyal Camp (3,700m)",
    "Stargazing at 3,300m altitude",
    "Traditional Diamer hospitality"
  ]
)
attach_image(trip2, :hero_image, "https://images.unsplash.com/photo-1601918774946-25832a4be0d6?w=800&q=80", "fairy_meadows_hero.jpg")

[
  [1, "Islamabad to Raikot Bridge", "Drive along the Karakoram Highway to Raikot Bridge. Overnight at Tato village."],
  [2, "Trek to Fairy Meadows", "4-hour trek through forests. Set up camp. Evening bonfire."],
  [3, "Beyal Camp Trek", "Trek to Beyal Camp for closer Nanga Parbat views. Packed lunch on the trail."],
  [4, "Free Day at Meadows", "Rest, photograph, explore. Optional trek to viewpoint. Night stargazing session."],
  [5, "Descend & Return", "Morning trek down. Drive back to Islamabad."]
].each { |day, title, desc| trip2.itinerary_days.create!(day: day, title: title, desc: desc) }

# ─── Trip 3: Skardu & Deosai Expedition ──────────────────
trip3 = Trip.create!(
  host: planner,
  title: "Skardu & Deosai Expedition",
  subtitle: "Lakes, Deserts & the Second Highest Plateau",
  description: "A comprehensive 7-day trip covering Skardu's cold deserts, Upper and Lower Kachura Lakes, Shangrila Resort, and the vast Deosai Plains. Spot the Himalayan brown bear, visit Sheosar Lake, and experience the raw beauty of Baltistan.",
  location: "Skardu, Gilgit-Baltistan",
  price: 55000,
  currency: "PKR",
  duration: "7 days",
  start_date: "2026-07-20",
  end_date: "2026-07-26",
  total_seats: 12,
  status: :active,
  trip_type: :casual,
  tags: ["Adventure", "Wildlife", "Lakes"],
  highlights: [
    "Drive across Deosai Plains (4,114m)",
    "Spot Himalayan brown bears",
    "Sheosar Lake — one of the highest lakes in the world",
    "Shangrila Resort (Heaven on Earth)",
    "Upper Kachura Lake boat ride",
    "Skardu Fort panoramic views",
    "Cold desert safari"
  ]
)
attach_image(trip3, :hero_image, "https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=800&q=80", "skardu_hero.jpg")

[
  [1, "Islamabad to Skardu", "Scenic flight to Skardu. Check-in & rest. Evening Skardu Fort visit."],
  [2, "Shangrila & Kachura", "Shangrila Resort, Lower Kachura Lake. Afternoon at Upper Kachura — boat ride."],
  [3, "Deosai Plains", "Full day on Deosai. Wildlife spotting. Packed lunch on the plateau."],
  [4, "Sheosar Lake", "Drive to Sheosar Lake. Photography session. Return to Skardu."],
  [5, "Cold Desert & Shigar", "Skardu cold desert safari. Visit Shigar Fort heritage hotel."],
  [6, "Satpara Lake & Bazaar", "Morning at Satpara Lake. Afternoon free for Skardu bazaar shopping."],
  [7, "Departure", "Morning flight back to Islamabad."]
].each { |day, title, desc| trip3.itinerary_days.create!(day: day, title: title, desc: desc) }

# ─── Trip 4: KKH Motorcycle Tour (Bike Trip) ─────────────
trip4 = Trip.create!(
  host: planner3,
  title: "Karakoram Highway Ride",
  subtitle: "The Ultimate Motorcycle Adventure",
  description: "Ride the legendary Karakoram Highway from Islamabad to Khunjerab Pass — the highest paved border crossing in the world at 4,693m. Full mechanical support, camping gear, and a chase vehicle included.",
  location: "Karakoram Highway, Pakistan",
  price: 65000,
  currency: "PKR",
  duration: "10 days",
  start_date: "2026-08-01",
  end_date: "2026-08-10",
  total_seats: 8,
  status: :active,
  trip_type: :bike_trip,
  tags: ["Bike", "Adventure", "Mountain"],
  highlights: [
    "Ride the highest paved road in the world",
    "Cross Khunjerab Pass at 4,693m",
    "Camp by Attabad Lake",
    "Visit Passu Cones and Karimabad",
    "Full mechanical support vehicle",
    "10 days of pure mountain riding"
  ]
)
attach_image(trip4, :hero_image, "https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=800&q=80", "kkh_bike_hero.jpg")

[
  [1, "Islamabad Departure", "Gear check, briefing, ride to Abbottabad"],
  [2, "Mansehra to Chilas", "Enter the Karakoram range. Ride along the Indus."],
  [3, "Chilas to Gilgit", "Dramatic mountain scenery. Arrive in Gilgit city."],
  [4, "Gilgit to Karimabad", "Explore Baltit Fort & Altit Fort."],
  [5, "Karimabad Rest Day", "Eagle's Nest viewpoint. Local food trail."],
  [6, "Karimabad to Passu", "Cross Passu suspension bridge. Glacier views."],
  [7, "Passu to Khunjerab", "Reach the China border at 4,693m."],
  [8, "Khunjerab to Attabad", "Ride back. Camp by Attabad Lake."],
  [9, "Attabad to Gilgit", "Morning boat ride on Attabad. Ride to Gilgit."],
  [10, "Gilgit to Islamabad", "Return flight. Bikes shipped separately."]
].each { |day, title, desc| trip4.itinerary_days.create!(day: day, title: title, desc: desc) }

# ─── Trip 5: Swat Valley Family Tour ─────────────────────
trip5 = Trip.create!(
  host: planner2,
  title: "Swat Valley Family Tour",
  subtitle: "The Switzerland of Pakistan",
  description: "A relaxed 4-day family tour of Swat Valley. Visit Mingora, Malam Jabba ski resort, Fizagat Park, the Buddhist ruins of Butkara, and the stunning Mahodand Lake. All hotels are family-friendly with separate arrangements.",
  location: "Swat Valley, KPK",
  price: 28000,
  currency: "PKR",
  duration: "4 days",
  start_date: "2026-06-25",
  end_date: "2026-06-28",
  total_seats: 20,
  status: :active,
  trip_type: :family,
  tags: ["Family", "Cultural", "Nature"],
  highlights: [
    "Family-friendly hotels throughout",
    "Malam Jabba chairlift ride",
    "Buddhist heritage sites",
    "Fizagat Park picnic",
    "Mahodand Lake day trip",
    "Mingora bazaar shopping"
  ]
)
attach_image(trip5, :hero_image, "https://images.unsplash.com/photo-1597074866923-dc0589150358?w=800&q=80", "swat_hero.jpg")

[
  [1, "Islamabad to Mingora", "Drive via Motorway. Check-in at hotel. Evening bazaar walk."],
  [2, "Malam Jabba & Fizagat", "Chairlift at Malam Jabba. Afternoon at Fizagat Park."],
  [3, "Kalam & Mahodand Lake", "Full day trip to Kalam and Mahodand Lake. Trout lunch."],
  [4, "Butkara & Return", "Visit Butkara Buddhist ruins. Drive back to Islamabad."]
].each { |day, title, desc| trip5.itinerary_days.create!(day: day, title: title, desc: desc) }

# ─── Trip 6: Neelum Valley Escape ─────────────────────────
trip6 = Trip.create!(
  host: planner,
  title: "Neelum Valley Escape",
  subtitle: "Kashmir's Hidden Paradise",
  description: "Explore the mesmerizing Neelum Valley — from Muzaffarabad to Kel. Dense forests, gushing streams, and wooden bridges. One of the most beautiful valleys in Azad Kashmir, still untouched by mass tourism.",
  location: "Neelum Valley, Azad Kashmir",
  price: 32000,
  currency: "PKR",
  duration: "5 days",
  start_date: "2026-08-15",
  end_date: "2026-08-19",
  total_seats: 12,
  status: :active,
  trip_type: :casual,
  tags: ["Adventure", "Nature", "Kashmir"],
  highlights: [
    "Drive along the Neelum River",
    "Visit Sharda Peeth ruins",
    "Camp at Kel village",
    "Cross wooden suspension bridges",
    "Ratti Gali Lake trek (optional)"
  ]
)
attach_image(trip6, :hero_image, "https://images.unsplash.com/photo-1566837945700-30057527ade0?w=800&q=80", "neelum_hero.jpg")

[
  [1, "Islamabad to Muzaffarabad", "Drive to Muzaffarabad. Visit Red Fort. Check-in."],
  [2, "Muzaffarabad to Keran", "Drive along Neelum River. Stop at Dhani waterfall. Camp at Keran."],
  [3, "Keran to Sharda", "Visit Sharda University ruins. Cross wooden bridges. Camp at Sharda."],
  [4, "Sharda to Kel", "Drive to Kel — the last accessible village. Bonfire night."],
  [5, "Return to Islamabad", "Morning drive back via Muzaffarabad."]
].each { |day, title, desc| trip6.itinerary_days.create!(day: day, title: title, desc: desc) }

# ─── Trip 7: Naltar Valley Winter Trip ────────────────────
trip7 = Trip.create!(
  host: planner2,
  title: "Naltar Valley Winter Escape",
  subtitle: "Colorful Lakes & Powder Snow",
  description: "Visit Pakistan's hidden gem — Naltar Valley with its three legendary colorful lakes and one of the country's few ski resorts. This winter trip combines skiing, snow hiking, and photography in a pristine valley near Gilgit.",
  location: "Naltar Valley, Gilgit-Baltistan",
  price: 42000,
  currency: "PKR",
  duration: "4 days",
  start_date: "2026-12-20",
  end_date: "2026-12-23",
  total_seats: 10,
  status: :active,
  trip_type: :casual,
  tags: ["Winter", "Skiing", "Lakes"],
  highlights: [
    "Naltar's three colorful lakes",
    "Skiing at Naltar Ski Resort",
    "Snow hiking through pine forests",
    "Panoramic valley photography",
    "Warm bonfire nights"
  ]
)
attach_image(trip7, :hero_image, "https://images.unsplash.com/photo-1517483000871-1dbf64a6e1c6?w=800&q=80", "naltar_hero.jpg")

[
  [1, "Gilgit to Naltar", "Drive from Gilgit to Naltar Valley. Settle into lodge."],
  [2, "Naltar Lakes", "Trek to the three colorful lakes. Photography session."],
  [3, "Ski Day", "Full day at Naltar Ski Resort. Lessons available for beginners."],
  [4, "Return", "Morning snow hike. Drive back to Gilgit."]
].each { |day, title, desc| trip7.itinerary_days.create!(day: day, title: title, desc: desc) }

# ─── Trip 8: Couple Trip — Hunza Honeymoon ────────────────
trip8 = Trip.create!(
  host: planner2,
  title: "Hunza Honeymoon Getaway",
  subtitle: "Romance in the Mountains",
  description: "A premium couple-only trip designed for honeymooners and couples. Private transfers, boutique hotel stays in Karimabad, candlelight dinners with mountain views, and a private Attabad Lake boat ride.",
  location: "Hunza Valley, Gilgit-Baltistan",
  price: 85000,
  currency: "PKR",
  duration: "5 days",
  start_date: "2026-09-10",
  end_date: "2026-09-14",
  total_seats: 6,
  status: :active,
  trip_type: :couple_trip,
  tags: ["Couple", "Premium", "Romantic"],
  highlights: [
    "Private airport transfers",
    "Boutique hotel in Karimabad",
    "Candlelight dinner at Eagle's Nest",
    "Private Attabad Lake boat ride",
    "Couple photoshoot with Rakaposhi backdrop",
    "Spa & wellness session"
  ]
)
attach_image(trip8, :hero_image, "https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800&q=80", "hunza_couple_hero.jpg")

[
  [1, "Arrival in Gilgit", "Private transfer to Karimabad. Check-in at boutique hotel. Welcome dinner."],
  [2, "Karimabad Heritage Walk", "Baltit Fort, Altit Fort. Afternoon tea at Eagle's Nest. Sunset views."],
  [3, "Attabad Lake", "Private boat ride. Lakeside lunch. Photography session."],
  [4, "Rakaposhi Viewpoint", "Drive to Rakaposhi viewpoint. Couple photoshoot. Spa session in evening."],
  [5, "Departure", "Breakfast with mountain views. Transfer to Gilgit airport."]
].each { |day, title, desc| trip8.itinerary_days.create!(day: day, title: title, desc: desc) }

puts "  Created #{Trip.count} trips with itineraries"

# ═══════════════════════════════════════════════════════════
#  BOOKINGS
# ═══════════════════════════════════════════════════════════
Booking.create!(trip: trip1, user: traveler, amount: 45000, status: :confirmed)
Booking.create!(trip: trip1, user: traveler2, amount: 45000, status: :confirmed)
Booking.create!(trip: trip2, user: traveler3, amount: 35000, status: :pending)
Booking.create!(trip: trip3, user: traveler, amount: 55000, status: :confirmed)
Booking.create!(trip: trip4, user: traveler2, amount: 65000, status: :pending)
Booking.create!(trip: trip5, user: traveler, amount: 28000, status: :confirmed)
Booking.create!(trip: trip5, user: traveler3, amount: 28000, status: :confirmed)
puts "  Created #{Booking.count} bookings"

# ═══════════════════════════════════════════════════════════
#  REVIEWS
# ═══════════════════════════════════════════════════════════
Review.create!(trip: trip1, user: traveler, rating: 5, text: "Hunza was a dream! Usman bhai's local knowledge made every stop special. The Eagle's Nest sunset was the highlight of my life.")
Review.create!(trip: trip1, user: traveler2, rating: 4, text: "Great trip overall. Beautiful views, good food. Only suggestion — one more day for Attabad would've been perfect.")
Review.create!(trip: trip3, user: traveler, rating: 5, text: "Deosai was out of this world. We saw 3 brown bears! Sheosar Lake at dawn is something I'll never forget.")
Review.create!(trip: trip5, user: traveler, rating: 5, text: "Perfect family trip. Kids loved the chairlift at Malam Jabba. Hotels were clean and well-arranged. Highly recommend!")
Review.create!(trip: trip5, user: traveler3, rating: 4, text: "Swat is beautiful. Mahodand Lake was the best part. Would have liked more time in Kalam though.")
puts "  Created #{Review.count} reviews"

# ═══════════════════════════════════════════════════════════
#  TRIP REQUESTS
# ═══════════════════════════════════════════════════════════
TripRequest.create!(
  user: traveler, planner: planner, destination: "Concordia & K2 Base Camp",
  start_date: "2026-09-01", end_date: "2026-09-15",
  seats: 2, category: "Adventure", budget: 120000,
  note: "We're experienced trekkers. Want a private guided trek to K2 base camp via Concordia. Need porter support.",
  status: :accepted
)
TripRequest.create!(
  user: traveler2, planner: planner, destination: "Chitral & Kalash Valley",
  start_date: "2026-08-15", end_date: "2026-08-22",
  seats: 4, category: "Cultural", budget: 80000,
  note: "Group of 4 friends interested in Kalash culture. Want to attend a Kalash festival if possible.",
  status: :pending
)
TripRequest.create!(
  user: traveler3, planner: planner2, destination: "Kumrat Valley",
  start_date: "2026-07-10", end_date: "2026-07-14",
  seats: 2, category: "Nature", budget: 40000,
  note: "Honeymoon trip. Looking for a quiet, romantic getaway in Kumrat.",
  status: :pending
)
puts "  Created #{TripRequest.count} trip requests"

# ═══════════════════════════════════════════════════════════
#  PLANNER REVIEWS
# ═══════════════════════════════════════════════════════════
PlannerReview.create!(user: traveler, planner: planner, rating: 5, text: "Usman bhai is the best guide in the north. Knows every trail, every local family. Makes you feel at home in the mountains.")
PlannerReview.create!(user: traveler2, planner: planner, rating: 4, text: "Well organized trips. Good attention to safety. Could improve on food variety.")
PlannerReview.create!(user: traveler, planner: planner2, rating: 5, text: "Ayesha's tours are perfect for families. She thinks of everything — from kids' activities to dietary needs.")
PlannerReview.create!(user: traveler3, planner: planner2, rating: 5, text: "Amazing experience with Baig Travels. Ayesha is so passionate about showcasing Pakistan.")
PlannerReview.create!(user: traveler2, planner: planner3, rating: 4, text: "Haider knows KKH like the back of his hand. Best bike tour operator in Pakistan.")
puts "  Created #{PlannerReview.count} planner reviews"

# ═══════════════════════════════════════════════════════════
#  PLACES
# ═══════════════════════════════════════════════════════════
places_data = [
  { name: "Hunza Valley", region: "Gilgit-Baltistan", description: "A stunning valley in the Karakoram range, known for breathtaking views of Rakaposhi, ancient forts, and warm Hunzai hospitality.", latitude: 36.3167, longitude: 74.6500 },
  { name: "Fairy Meadows", region: "Gilgit-Baltistan", description: "A grassland at the base of Nanga Parbat (8,126m). Paradise for trekkers with unreal mountain views.", latitude: 35.3756, longitude: 74.5881 },
  { name: "Skardu", region: "Gilgit-Baltistan", description: "Gateway to K2 and the world's highest peaks. Home to Shangrila Resort, Deosai, and stunning lakes.", latitude: 35.2971, longitude: 75.6333 },
  { name: "Swat Valley", region: "Khyber Pakhtunkhwa", description: "The Switzerland of Pakistan. Lush valleys, Buddhist ruins, and crystal clear rivers.", latitude: 35.2227, longitude: 72.3526 },
  { name: "Neelum Valley", region: "Azad Kashmir", description: "A beautiful valley with dense forests, streams, and freshwater lakes. Still largely untouched.", latitude: 34.5978, longitude: 73.9068 },
  { name: "Attabad Lake", region: "Gilgit-Baltistan", description: "A turquoise lake formed in 2010 by a landslide. Popular for boating and jet skiing.", latitude: 36.3167, longitude: 74.8500 },
  { name: "Kumrat Valley", region: "Khyber Pakhtunkhwa", description: "A hidden paradise in Upper Dir, with lush meadows and crystal clear rivers.", latitude: 35.5172, longitude: 72.2275 },
  { name: "Deosai National Park", region: "Gilgit-Baltistan", description: "The second highest plateau in the world at 4,114m. Home to Himalayan brown bears.", latitude: 35.0897, longitude: 75.4033 },
  { name: "Khunjerab Pass", region: "Gilgit-Baltistan", description: "Highest paved international border crossing at 4,693m on the China-Pakistan border.", latitude: 36.8500, longitude: 75.4167 },
  { name: "Naltar Valley", region: "Gilgit-Baltistan", description: "Famous for its three colorful lakes and ski resort. A hidden gem near Gilgit.", latitude: 36.1667, longitude: 74.1833 },
  { name: "Rakaposhi Base Camp", region: "Gilgit-Baltistan", description: "Trek to the base of Rakaposhi (7,788m) from Minapin village. Stunning views.", latitude: 36.1500, longitude: 74.5333 },
  { name: "Kalam", region: "Khyber Pakhtunkhwa", description: "A green town in upper Swat with mountains, waterfalls, and dense forests.", latitude: 35.4897, longitude: 72.5861 },
  { name: "Chitral", region: "Khyber Pakhtunkhwa", description: "Remote valley bordering Afghanistan, home to the Kalasha people and their ancient culture.", latitude: 35.8517, longitude: 71.7864 },
  { name: "Ratti Gali Lake", region: "Azad Kashmir", description: "An alpine glacial lake at 12,130 feet in the Neelum Valley. Crystal blue waters surrounded by peaks.", latitude: 34.7833, longitude: 74.3667 },
  { name: "Shogran", region: "Khyber Pakhtunkhwa", description: "A hill station in Kaghan Valley at 7,749 feet with views of Makra and Malika Parbat.", latitude: 34.6333, longitude: 73.4833 },
  { name: "Shigar", region: "Gilgit-Baltistan", description: "Home to the restored Shigar Fort (now a heritage hotel). Gateway to Baltoro and K2.", latitude: 35.4264, longitude: 75.7500 },
  { name: "Passu", region: "Gilgit-Baltistan", description: "Famous for its cathedral-shaped cones, glacier, and the thrilling suspension bridge over Hunza River.", latitude: 36.4881, longitude: 74.8917 },
  { name: "Malam Jabba", region: "Khyber Pakhtunkhwa", description: "Pakistan's premier ski resort in Swat. Skiing in winter, chairlift views year-round.", latitude: 35.1581, longitude: 72.5728 },
  { name: "Lahore Old City", region: "Punjab", description: "Cultural heart of Pakistan. Badshahi Mosque, Lahore Fort, and the vibrant Walled City food street.", latitude: 31.5820, longitude: 74.3293 },
  { name: "Naran", region: "Khyber Pakhtunkhwa", description: "Popular hill station in Kaghan Valley. Base for trips to Lake Saif-ul-Malook and Babusar Pass.", latitude: 34.9000, longitude: 73.6500 }
]

places_data.each do |pd|
  Place.create!(name: pd[:name], region: pd[:region], description: pd[:description], latitude: pd[:latitude], longitude: pd[:longitude])
end
puts "  Created #{Place.count} places"

# ═══════════════════════════════════════════════════════════
#  PLACE REVIEWS
# ═══════════════════════════════════════════════════════════
hunza = Place.find_by(name: "Hunza Valley")
fairy = Place.find_by(name: "Fairy Meadows")
skardu = Place.find_by(name: "Skardu")

PlaceReview.create!(place: hunza, user: traveler, rating: 5, text: "The most beautiful place I've ever visited. Rakaposhi views from Eagle's Nest are breathtaking!")
PlaceReview.create!(place: hunza, user: traveler2, rating: 5, text: "Incredible hospitality. The apricot season in summer is heavenly. Must visit!")
PlaceReview.create!(place: fairy, user: traveler, rating: 4, text: "The trek up is challenging but so worth it. Camping with Nanga Parbat in view is magical.")
PlaceReview.create!(place: fairy, user: traveler3, rating: 5, text: "Best camping experience of my life. No phone signal — just you and the mountain.")
PlaceReview.create!(place: skardu, user: traveler, rating: 5, text: "Skardu is another world. Upper Kachura Lake is the most peaceful place on earth.")
puts "  Created #{PlaceReview.count} place reviews"

# ═══════════════════════════════════════════════════════════
#  BIKE PROFILES
# ═══════════════════════════════════════════════════════════
BikeProfile.create!(user: traveler2, bike_model: "Honda CG 125", bike_cc: 125, experience_level: :intermediate, bio: "Weekend rider exploring Pakistan's highways. Dream: KKH end to end.")
BikeProfile.create!(user: traveler, bike_model: "Suzuki GS 150", bike_cc: 150, experience_level: :beginner, bio: "New to bike touring but love the mountains!")
puts "  Created #{BikeProfile.count} bike profiles"

# ═══════════════════════════════════════════════════════════
#  NOTIFICATIONS
# ═══════════════════════════════════════════════════════════
Notification.create!(user: traveler, title: "Welcome to Nazary!", body: "Your account is ready. Start exploring trips across Pakistan!", notification_type: :general)
Notification.create!(user: traveler, title: "Booking Confirmed", body: "Your booking for Hunza Valley Explorer has been confirmed by Malik Adventures", notification_type: :booking_update, data: { trip_id: trip1.id.to_s })
Notification.create!(user: traveler, title: "Trip Request Accepted", body: "Usman Malik accepted your trip request for K2 Base Camp", notification_type: :request_update)
Notification.create!(user: planner, title: "New Join Request", body: "Zainab Hussain wants to join Hunza Valley Explorer", notification_type: :booking_update, data: { trip_id: trip1.id.to_s })
Notification.create!(user: planner, title: "New Review", body: "Zainab Hussain left a 5-star review", notification_type: :review)
Notification.create!(user: planner, title: "New Trip Request", body: "Bilal Ahmed sent you a trip request for Chitral", notification_type: :request_update)
Notification.create!(user: planner2, title: "New Join Request", body: "Mehreen Khan wants to join Fairy Meadows Trek", notification_type: :booking_update, data: { trip_id: trip2.id.to_s })
puts "  Created #{Notification.count} notifications"

# ═══════════════════════════════════════════════════════════
#  COLLECTIONS
# ═══════════════════════════════════════════════════════════
c1 = Collection.create!(title: "Summer Adventures", subtitle: "Best trips for summer 2026")
c2 = Collection.create!(title: "Family Friendly", subtitle: "Trips the whole family will love")
c3 = Collection.create!(title: "Bike Tours", subtitle: "Premium motorcycle adventures")
CollectionTrip.create!(collection: c1, trip: trip1)
CollectionTrip.create!(collection: c1, trip: trip2)
CollectionTrip.create!(collection: c1, trip: trip3)
CollectionTrip.create!(collection: c2, trip: trip5)
CollectionTrip.create!(collection: c2, trip: trip6)
CollectionTrip.create!(collection: c3, trip: trip4)
puts "  Created #{Collection.count} collections"

# ═══════════════════════════════════════════════════════════
#  ARRANGEMENT REQUESTS
# ═══════════════════════════════════════════════════════════
ArrangementRequest.create!(
  traveler: traveler,
  preferred_destination: "Hunza Valley",
  travel_dates: "2026-09-15 to 2026-09-22",
  group_size: 4,
  budget_min: 20000,
  budget_max: 60000,
  special_notes: "Family of 4. Want comfortable hotels. Interested in Karimabad and Attabad Lake.",
  status: :pending
)
puts "  Created arrangement requests"

# ═══════════════════════════════════════════════════════════
#  ADMIN & SYSTEM USERS
# ═══════════════════════════════════════════════════════════
User.find_or_create_by!(email: "admin@nazary.pk") do |u|
  u.name = "Nazary Admin"
  u.password = "NazaryAdmin2024!"
  u.role = :planner
  u.admin = true
  u.verified = true
  u.profile_completed = true
  u.agency_name = "Nazary Admin"
  u.agency_tagline = "Platform Administration"
  u.phone = "+920000000000"
end

puts ""
puts "=" * 60
puts "  NAZARY SEED DATA COMPLETE"
puts "=" * 60
puts ""
puts "  LOGIN ACCOUNTS:"
puts "  ─────────────────────────────────────────"
puts "  TRAVELER:"
puts "    Email:    zainab@nazary.com"
puts "    Password: password123"
puts ""
puts "  PLANNER:"
puts "    Email:    usman@nazary.com"
puts "    Password: password123"
puts ""
puts "  OTHER ACCOUNTS (all password: password123):"
puts "    Traveler: bilal@nazary.com"
puts "    Traveler: mehreen@nazary.com"
puts "    Planner:  ayesha@nazary.com"
puts "    Planner:  haider@nazary.com"
puts ""
puts "  Admin:  admin@nazary.pk / NazaryAdmin2024!"
puts "  ─────────────────────────────────────────"
puts "  #{Trip.count} trips | #{User.count} users | #{Place.count} places"
puts "=" * 60
