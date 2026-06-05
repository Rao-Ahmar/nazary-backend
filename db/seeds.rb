puts "Seeding Nazary..."

# ─── Cleanup ──────────────────────────────────────────────
# Reset everything for a clean seed
ActiveStorage::Attachment.delete_all rescue nil
ActiveStorage::Blob.delete_all rescue nil
%w[PaymentProof PaymentAccount ArrangementRequest CollectionTrip Collection BikeProfile PlaceReview Place
   Notification PlannerReview TripRequest Review Booking ItineraryDay TripUpdate Trip
   CoupleRequest OtpVerification Category User].each do |name|
  name.constantize.delete_all
rescue StandardError
  nil
end

puts "  Cleaned existing data"

# ─── Categories ───────────────────────────────────────────
categories = [
  { label: "Luxury",         icon: "diamond-outline" },
  { label: "Party",          icon: "musical-notes-outline" },
  { label: "Adventures",     icon: "compass-outline" },
  { label: "Budget Friendly", icon: "wallet-outline" },
  { label: "Couple Trips",   icon: "heart-outline" },
  { label: "Family Trips",   icon: "people-outline" },
  { label: "Friends Trips",  icon: "beer-outline" },
]
categories.each { |c| Category.create!(label: c[:label], icon: c[:icon]) }
puts "  Created #{Category.count} categories"

# ─── Planner 1: Usman Malik ──────────────────────────────
planner = User.find_or_create_by!(email: "usman@nazary.com") do |u|
  u.name = "Usman Malik"
  u.password = "password123"
  u.role = :planner
  u.bio = "Born and raised in Gilgit. Leading expeditions across Karakoram and Hindukush for 10 years. Every trail has a story."
  u.guild = "Karakoram Explorers"
  u.agency_name = "Malik Adventures"
  u.agency_tagline = "Your gateway to the mountains"
  u.years_experience = 10
  u.phone = "+923001234567"
  u.phone_verified = true
  u.profile_completed = true
  u.premium = true
  u.verified = true
  u.slug = "malik-adventures"
  u.agency_name_normalized = "malik adventures"
end

# ─── Planner 2: Ayesha Baig ──────────────────────────────
planner2 = User.find_or_create_by!(email: "ayesha@nazary.com") do |u|
  u.name = "Ayesha Baig"
  u.password = "password123"
  u.role = :planner
  u.bio = "Passionate about responsible tourism in Pakistan. Specializing in family-friendly and cultural tours of the northern areas."
  u.guild = "Northern Sisters"
  u.agency_name = "Baig Travels"
  u.agency_tagline = "Discover the undiscovered"
  u.years_experience = 7
  u.phone = "+923009876543"
  u.phone_verified = true
  u.profile_completed = true
  u.premium = true
  u.verified = true
  u.slug = "baig-travels"
  u.agency_name_normalized = "baig travels"
end

# ─── Planner 3: Haider Shah ──────────────────────────────
planner3 = User.find_or_create_by!(email: "haider@nazary.com") do |u|
  u.name = "Haider Shah"
  u.password = "password123"
  u.role = :planner
  u.bio = "Motorcycle touring specialist. Ridden every pass in northern Pakistan. If it has two wheels and a mountain road, I'm in."
  u.guild = "KKH Riders"
  u.agency_name = "Shah Bike Tours"
  u.agency_tagline = "Ride the roof of the world"
  u.years_experience = 5
  u.phone = "+923331112233"
  u.phone_verified = true
  u.profile_completed = true
  u.premium = true
  u.verified = true
  u.slug = "shah-bike-tours"
  u.agency_name_normalized = "shah bike tours"
end

puts "  Created 3 planners"

# ─── Traveler 1: Zainab Hussain ──────────────────────────
traveler = User.find_or_create_by!(email: "zainab@nazary.com") do |u|
  u.name = "Zainab Hussain"
  u.password = "password123"
  u.role = :traveler
  u.phone = "+923005551234"
  u.phone_verified = true
  u.profile_completed = true
  u.premium = true
end

# ─── Traveler 2: Bilal Ahmed ─────────────────────────────
traveler2 = User.find_or_create_by!(email: "bilal@nazary.com") do |u|
  u.name = "Bilal Ahmed"
  u.password = "password123"
  u.role = :traveler
  u.phone = "+923007778899"
  u.phone_verified = true
  u.profile_completed = true
end

# ─── Traveler 3: Mehreen Khan ────────────────────────────
traveler3 = User.find_or_create_by!(email: "mehreen@nazary.com") do |u|
  u.name = "Mehreen Khan"
  u.password = "password123"
  u.role = :traveler
  u.phone = "+923214567890"
  u.phone_verified = true
  u.profile_completed = true
end

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
  tags: ["Adventures", "Family Trips"],
  highlights: [
    "Visit the 700-year-old Baltit Fort",
    "Sunrise at Eagle's Nest viewpoint",
    "Boating on turquoise Attabad Lake",
    "Walk across Passu Suspension Bridge",
    "Traditional Hunzai apricot feast",
    "Photography at Passu Cones"
  ]
)
attach_image(trip1, :hero_image, "https://images.unsplash.com/photo-1586348943529-beaae6c28db9?w=1200&q=80", "hunza_hero.jpg")
attach_image(trip1, :gallery, "https://images.unsplash.com/photo-1566837945700-30057527ade0?w=800&q=80", "hunza_gallery_1.jpg")
attach_image(trip1, :gallery, "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80", "hunza_gallery_2.jpg")
attach_image(trip1, :gallery, "https://images.unsplash.com/photo-1614094082869-cd4e4b2905c7?w=800&q=80", "hunza_gallery_3.jpg")

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
  tags: ["Adventures", "Budget Friendly"],
  highlights: [
    "Trek through dense pine forests",
    "Camp with Nanga Parbat views",
    "Visit Beyal Camp (3,700m)",
    "Stargazing at 3,300m altitude",
    "Traditional Diamer hospitality"
  ]
)
attach_image(trip2, :hero_image, "https://images.unsplash.com/photo-1601918774946-25832a4be0d6?w=1200&q=80", "fairy_meadows_hero.jpg")
attach_image(trip2, :gallery, "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&q=80", "fairy_gallery_1.jpg")
attach_image(trip2, :gallery, "https://images.unsplash.com/photo-1486870591958-9b9d0d1dda99?w=800&q=80", "fairy_gallery_2.jpg")
attach_image(trip2, :gallery, "https://images.unsplash.com/photo-1454496522488-7a8e488e8606?w=800&q=80", "fairy_gallery_3.jpg")

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
  tags: ["Adventures", "Luxury"],
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
attach_image(trip3, :hero_image, "https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=1200&q=80", "skardu_hero.jpg")
attach_image(trip3, :gallery, "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80", "skardu_gallery_1.jpg")
attach_image(trip3, :gallery, "https://images.unsplash.com/photo-1494500764479-0c8f2919a3d8?w=800&q=80", "skardu_gallery_2.jpg")
attach_image(trip3, :gallery, "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=800&q=80", "skardu_gallery_3.jpg")

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
  tags: ["Adventures", "Friends Trips"],
  highlights: [
    "Ride the highest paved road in the world",
    "Cross Khunjerab Pass at 4,693m",
    "Camp by Attabad Lake",
    "Visit Passu Cones and Karimabad",
    "Full mechanical support vehicle",
    "10 days of pure mountain riding"
  ]
)
attach_image(trip4, :hero_image, "https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=1200&q=80", "kkh_bike_hero.jpg")
attach_image(trip4, :gallery, "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800&q=80", "kkh_gallery_1.jpg")
attach_image(trip4, :gallery, "https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800&q=80", "kkh_gallery_2.jpg")
attach_image(trip4, :gallery, "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800&q=80", "kkh_gallery_3.jpg")

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
  tags: ["Family Trips", "Budget Friendly"],
  highlights: [
    "Family-friendly hotels throughout",
    "Malam Jabba chairlift ride",
    "Buddhist heritage sites",
    "Fizagat Park picnic",
    "Mahodand Lake day trip",
    "Mingora bazaar shopping"
  ]
)
attach_image(trip5, :hero_image, "https://images.unsplash.com/photo-1597074866923-dc0589150358?w=1200&q=80", "swat_hero.jpg")
attach_image(trip5, :gallery, "https://images.unsplash.com/photo-1472396961693-142e6e269027?w=800&q=80", "swat_gallery_1.jpg")
attach_image(trip5, :gallery, "https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800&q=80", "swat_gallery_2.jpg")
attach_image(trip5, :gallery, "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=800&q=80", "swat_gallery_3.jpg")

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
  tags: ["Adventures", "Friends Trips"],
  highlights: [
    "Drive along the Neelum River",
    "Visit Sharda Peeth ruins",
    "Camp at Kel village",
    "Cross wooden suspension bridges",
    "Ratti Gali Lake trek (optional)"
  ]
)
attach_image(trip6, :hero_image, "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=1200&q=80", "neelum_hero.jpg")
attach_image(trip6, :gallery, "https://images.unsplash.com/photo-1448375240586-882707db888b?w=800&q=80", "neelum_gallery_1.jpg")
attach_image(trip6, :gallery, "https://images.unsplash.com/photo-1440581572325-0bea30075d9d?w=800&q=80", "neelum_gallery_2.jpg")
attach_image(trip6, :gallery, "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800&q=80", "neelum_gallery_3.jpg")

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
  tags: ["Adventures", "Party"],
  highlights: [
    "Naltar's three colorful lakes",
    "Skiing at Naltar Ski Resort",
    "Snow hiking through pine forests",
    "Panoramic valley photography",
    "Warm bonfire nights"
  ]
)
attach_image(trip7, :hero_image, "https://images.unsplash.com/photo-1517483000871-1dbf64a6e1c6?w=1200&q=80", "naltar_hero.jpg")
attach_image(trip7, :gallery, "https://images.unsplash.com/photo-1491002052546-bf38f186af56?w=800&q=80", "naltar_gallery_1.jpg")
attach_image(trip7, :gallery, "https://images.unsplash.com/photo-1482192505345-5655af888cc4?w=800&q=80", "naltar_gallery_2.jpg")
attach_image(trip7, :gallery, "https://images.unsplash.com/photo-1477346611705-65d1883cee1e?w=800&q=80", "naltar_gallery_3.jpg")

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
  tags: ["Couple Trips", "Luxury"],
  highlights: [
    "Private airport transfers",
    "Boutique hotel in Karimabad",
    "Candlelight dinner at Eagle's Nest",
    "Private Attabad Lake boat ride",
    "Couple photoshoot with Rakaposhi backdrop",
    "Spa & wellness session"
  ]
)
attach_image(trip8, :hero_image, "https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80", "hunza_couple_hero.jpg")
attach_image(trip8, :gallery, "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800&q=80", "couple_gallery_1.jpg")
attach_image(trip8, :gallery, "https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800&q=80", "couple_gallery_2.jpg")
attach_image(trip8, :gallery, "https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=800&q=80", "couple_gallery_3.jpg")

[
  [1, "Arrival in Gilgit", "Private transfer to Karimabad. Check-in at boutique hotel. Welcome dinner."],
  [2, "Karimabad Heritage Walk", "Baltit Fort, Altit Fort. Afternoon tea at Eagle's Nest. Sunset views."],
  [3, "Attabad Lake", "Private boat ride. Lakeside lunch. Photography session."],
  [4, "Rakaposhi Viewpoint", "Drive to Rakaposhi viewpoint. Couple photoshoot. Spa session in evening."],
  [5, "Departure", "Breakfast with mountain views. Transfer to Gilgit airport."]
].each { |day, title, desc| trip8.itinerary_days.create!(day: day, title: title, desc: desc) }

# ─── Trip 9: Chitral & Kalash Valley ─────────────────────
trip9 = Trip.create!(
  host: planner3,
  title: "Chitral & Kalash Cultural Tour",
  subtitle: "Ancient Traditions of the Hindu Kush",
  description: "Discover the unique Kalash people in the valleys of Chitral. Visit Bumburet, Rumbur, and Birir valleys. Attend local festivals, experience their ancient pagan traditions, and explore the dramatic Hindu Kush mountain scenery.",
  location: "Chitral, Khyber Pakhtunkhwa",
  price: 48000,
  currency: "PKR",
  duration: "6 days",
  start_date: "2026-07-15",
  end_date: "2026-07-20",
  total_seats: 12,
  status: :active,
  trip_type: :casual,
  tags: ["Adventures", "Friends Trips"],
  highlights: [
    "Visit three Kalash valleys",
    "Attend traditional Kalash ceremonies",
    "Cross Lowari Pass (3,118m)",
    "Explore Chitral Fort",
    "Taste Kalash wine and local food",
    "Hindu Kush mountain scenery"
  ]
)
attach_image(trip9, :hero_image, "https://images.unsplash.com/photo-1486870591958-9b9d0d1dda99?w=1200&q=80", "chitral_hero.jpg")
attach_image(trip9, :gallery, "https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800&q=80", "chitral_gallery_1.jpg")
attach_image(trip9, :gallery, "https://images.unsplash.com/photo-1440581572325-0bea30075d9d?w=800&q=80", "chitral_gallery_2.jpg")

[
  [1, "Islamabad to Chitral", "Fly to Chitral. Check-in. Evening walk at Chitral bazaar."],
  [2, "Chitral Fort & City", "Explore Chitral Fort, Shahi Mosque. Visit the polo ground."],
  [3, "Bumburet Valley", "Drive to Bumburet. Meet Kalash families. Cultural immersion."],
  [4, "Rumbur Valley", "Trek between valleys. Visit ancient temples. Traditional music night."],
  [5, "Birir Valley", "Visit the most traditional Kalash valley. Cheese making. Photography."],
  [6, "Return", "Morning drive back to Chitral. Afternoon flight to Islamabad."]
].each { |day, title, desc| trip9.itinerary_days.create!(day: day, title: title, desc: desc) }

# ─── Trip 10: Kumrat Valley Escape ──────────────────────
trip10 = Trip.create!(
  host: planner,
  title: "Kumrat Valley Paradise",
  subtitle: "Pakistan's Best Kept Secret",
  description: "Explore the untouched beauty of Kumrat Valley in Upper Dir. Lush green meadows, the crystal-clear Panjkora River, dense pine forests, and Jahaz Banda (the meadow that looks like it's floating). A perfect escape from city life.",
  location: "Kumrat Valley, KPK",
  price: 30000,
  currency: "PKR",
  duration: "4 days",
  start_date: "2026-08-05",
  end_date: "2026-08-08",
  total_seats: 14,
  status: :active,
  trip_type: :casual,
  tags: ["Adventures", "Budget Friendly"],
  highlights: [
    "Camp by the Panjkora River",
    "Trek to Jahaz Banda meadow",
    "Swimming in natural pools",
    "Trout fishing",
    "Night camping under the stars"
  ]
)
attach_image(trip10, :hero_image, "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80", "kumrat_hero.jpg")
attach_image(trip10, :gallery, "https://images.unsplash.com/photo-1448375240586-882707db888b?w=800&q=80", "kumrat_gallery_1.jpg")
attach_image(trip10, :gallery, "https://images.unsplash.com/photo-1472396961693-142e6e269027?w=800&q=80", "kumrat_gallery_2.jpg")

[
  [1, "Islamabad to Thall", "Drive to Thall, Upper Dir. Check-in at guesthouse."],
  [2, "Kumrat Valley", "Enter the valley. Set up riverside camp. Afternoon fishing."],
  [3, "Jahaz Banda Trek", "Full day trek to Jahaz Banda. Packed lunch. Return for bonfire."],
  [4, "Return to Islamabad", "Pack up camp. Scenic drive back via Dir."]
].each { |day, title, desc| trip10.itinerary_days.create!(day: day, title: title, desc: desc) }

# ─── Trip 11: Ratti Gali Lake Trek ──────────────────────
trip11 = Trip.create!(
  host: planner2,
  title: "Ratti Gali Lake Trek",
  subtitle: "Kashmir's Alpine Jewel",
  description: "A challenging but rewarding trek to Ratti Gali Lake at 12,130 feet in the Neelum Valley. Crystal blue glacial waters surrounded by snow-capped peaks. For experienced hikers who want an unforgettable alpine experience.",
  location: "Neelum Valley, Azad Kashmir",
  price: 25000,
  currency: "PKR",
  duration: "3 days",
  start_date: "2026-07-25",
  end_date: "2026-07-27",
  total_seats: 8,
  status: :active,
  trip_type: :casual,
  tags: ["Adventures", "Budget Friendly"],
  highlights: [
    "Trek to 12,130 feet altitude",
    "Crystal blue glacial lake",
    "Camp beside the lake",
    "Snow-capped peak panoramas",
    "Wildflower meadows en route"
  ]
)
attach_image(trip11, :hero_image, "https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=1200&q=80", "ratti_gali_hero.jpg")
attach_image(trip11, :gallery, "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800&q=80", "ratti_gallery_1.jpg")
attach_image(trip11, :gallery, "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=800&q=80", "ratti_gallery_2.jpg")

[
  [1, "Islamabad to Dowarian", "Drive to Dowarian village in Neelum Valley. Night rest."],
  [2, "Trek to Ratti Gali", "6-hour trek through meadows and forests to the lake. Camp setup."],
  [3, "Lake Day & Return", "Sunrise photography. Trek back to Dowarian. Drive to Islamabad."]
].each { |day, title, desc| trip11.itinerary_days.create!(day: day, title: title, desc: desc) }

# ─── Trip 12: Naran & Lake Saif-ul-Malook ────────────────
trip12 = Trip.create!(
  host: planner,
  title: "Naran & Saif-ul-Malook",
  subtitle: "The Legendary Lake of Kaghan",
  description: "Visit the legendary Lake Saif-ul-Malook surrounded by fairy-tale peaks. Explore Naran town, drive Babusar Pass, and witness the beauty of Kaghan Valley in summer. Perfect for families and first-time northern visitors.",
  location: "Naran, Kaghan Valley",
  price: 22000,
  currency: "PKR",
  duration: "3 days",
  start_date: "2026-06-20",
  end_date: "2026-06-22",
  total_seats: 20,
  status: :active,
  trip_type: :family,
  tags: ["Family Trips", "Budget Friendly"],
  highlights: [
    "Visit Lake Saif-ul-Malook",
    "Jeep ride to the lake",
    "Lulusar Lake stop",
    "Naran town exploration",
    "Trout fish BBQ dinner"
  ]
)
attach_image(trip12, :hero_image, "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=1200&q=80", "naran_hero.jpg")
attach_image(trip12, :gallery, "https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=800&q=80", "naran_gallery_1.jpg")
attach_image(trip12, :gallery, "https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800&q=80", "naran_gallery_2.jpg")

[
  [1, "Islamabad to Naran", "Drive via Mansehra to Naran. Evening town walk."],
  [2, "Lake Saif-ul-Malook", "Jeep ride to the lake. Photography, boat ride. Return to Naran."],
  [3, "Lulusar Lake & Return", "Morning visit to Lulusar Lake. Drive back to Islamabad."]
].each { |day, title, desc| trip12.itinerary_days.create!(day: day, title: title, desc: desc) }

puts "  Created #{Trip.count} trips with itineraries and gallery images"

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
#  PLACES — Real Northern Pakistan Destinations
# ═══════════════════════════════════════════════════════════
places_data = [
  # ── Galyat Region ──────────────────────────────────────
  { name: "Mushkpuri Top", region: "Galyat", description: "The highest peak in the Galyat range at 2,800m, offering a rewarding short trek through dense pine and oak forests with panoramic 360-degree views of the Abbottabad hills and snow-clad Kashmir peaks.", latitude: 34.0850, longitude: 73.3850, elevation_meters: 2800 },
  { name: "Miranjani Top", region: "Galyat", description: "The highest peak in the Galyat hills near Nathia Gali at 2,992m. Rewards trekkers with sweeping views of the Himalayan foothills — one of the most accessible high-altitude hikes in Pakistan.", latitude: 34.0739, longitude: 73.3783, elevation_meters: 2992 },

  # ── Kaghan Valley ──────────────────────────────────────
  { name: "Naran", region: "Kaghan Valley", description: "A bustling hill station in the Kaghan Valley and gateway to the legendary Lake Saif-ul-Malook. Sits along the Kunhar River surrounded by snow-capped peaks.", latitude: 34.9090, longitude: 73.6500, elevation_meters: 2409 },
  { name: "Kaghan", region: "Kaghan Valley", description: "The historic namesake town of the Kaghan Valley, nestled along the Kunhar River with terraced fields and traditional wooden houses — a quieter alternative to Naran.", latitude: 34.7500, longitude: 73.5167, elevation_meters: 1981 },
  { name: "Sharan Forest", region: "Kaghan Valley", description: "A pristine pine forest plateau with untouched alpine meadows and sweeping views of snow-covered peaks. One of Pakistan's best-kept secrets for those seeking solitude in nature.", latitude: 34.7711, longitude: 73.3928, elevation_meters: 2400 },
  { name: "Shogran", region: "Kaghan Valley", description: "A picturesque hill station in the lower Kaghan Valley with stunning views of Makra Peak and Malika Parbat, accessible mountain beauty with comfortable guesthouses.", latitude: 34.6333, longitude: 73.4833, elevation_meters: 2362 },

  # ── Azad Kashmir ───────────────────────────────────────
  { name: "Neelum Valley", region: "Azad Kashmir", description: "A 200km-long valley of lush green forests, gushing rivers, and wooden bridges, still largely untouched by mass tourism — considered one of the most beautiful valleys in South Asia.", latitude: 34.5978, longitude: 73.9068, elevation_meters: nil },
  { name: "Sharda", region: "Azad Kashmir", description: "An ancient Buddhist learning center on the banks of the Neelum River, featuring the atmospheric ruins of Sharda Peeth — a critical cultural heritage site in Azad Kashmir.", latitude: 34.6833, longitude: 74.1167, elevation_meters: 1981 },
  { name: "Kel", region: "Azad Kashmir", description: "One of the last accessible villages in the upper Neelum Valley, sitting at the confluence of two mountain rivers amid towering peaks — base camp for the Ratti Gali Lake trek.", latitude: 34.7986, longitude: 74.2361, elevation_meters: 2097 },
  { name: "Arang Kel", region: "Azad Kashmir", description: "A remote hilltop settlement perched above Kel, reachable only by a steep hike or chairlift. Jaw-dropping views of snow-clad peaks and terraced fields earned it the name 'Pearl of Neelum Valley.'", latitude: 34.8000, longitude: 74.2500, elevation_meters: 2554 },
  { name: "Taobat", region: "Azad Kashmir", description: "The last village on the Neelum Valley road near the Line of Control, surrounded by towering mountains and pristine glacial streams — an untouched frontier for adventurous travelers.", latitude: 34.8150, longitude: 74.3028, elevation_meters: 2012 },
  { name: "Shounter Valley", region: "Azad Kashmir", description: "A breathtaking side valley branching off Neelum, home to the glacial Shounter Lake at over 3,000m surrounded by wildflower meadows — one of Kashmir's most pristine alpine environments.", latitude: 34.7417, longitude: 74.3111, elevation_meters: 3100 },
  { name: "Leepa Valley", region: "Azad Kashmir", description: "Accessible via the dramatic Reshian Pass, Leepa is a postcard-perfect valley of terraced rice fields, walnut orchards, and traditional Kashmiri wooden houses.", latitude: 34.3833, longitude: 73.9500, elevation_meters: 1921 },
  { name: "Ratti Gali Lake", region: "Azad Kashmir", description: "A pristine alpine glacial lake at 3,697m in the upper Neelum Valley, shimmering in turquoise and blue surrounded by snow-capped peaks and wildflower meadows.", latitude: 34.7833, longitude: 74.3667, elevation_meters: 3697 },

  # ── Diamer / Nanga Parbat Region ───────────────────────
  { name: "Fairy Meadows", region: "Diamer", description: "A legendary alpine meadow at 3,300m with a front-row seat to the massive north face of Nanga Parbat (8,126m). Camping under billions of stars at the edge of the world.", latitude: 35.3756, longitude: 74.5881, elevation_meters: 3300 },
  { name: "Beyal Camp", region: "Diamer", description: "A high-altitude camp above Fairy Meadows offering dramatically closer views of Nanga Parbat's Rakhiot Face and glacier — one of the most awe-inspiring mountain panoramas on Earth.", latitude: 35.3583, longitude: 74.5750, elevation_meters: 3680 },
  { name: "Nanga Parbat Base Camp", region: "Diamer", description: "Base camp of the world's ninth-highest mountain (8,126m), known as the 'Killer Mountain.' The Rupal Face here is the tallest mountain face in the world at over 4,600m vertical rise.", latitude: 35.2333, longitude: 74.6333, elevation_meters: 3967 },

  # ── Chitral Region ─────────────────────────────────────
  { name: "Chitral Town", region: "Chitral", description: "Capital of the former Chitral princely state in the Hindu Kush, featuring a historic fort, polo ground, and bustling bazaars — gateway to the unique Kalash valleys.", latitude: 35.8517, longitude: 71.7864, elevation_meters: 1498 },
  { name: "Kalash Valley", region: "Chitral", description: "Home to the ancient Kalash people who practice a unique pagan religion with vibrant festivals and colorful dress — a fascinating culture that has survived for millennia in the remote Hindu Kush.", latitude: 35.7292, longitude: 71.6833, elevation_meters: 1640 },

  # ── Swat Region ────────────────────────────────────────
  { name: "Swat Valley", region: "Swat", description: "Known as the 'Switzerland of Pakistan,' Swat is a lush green paradise with ancient Buddhist ruins, crystal-clear rivers, and archaeological heritage rivaling anything in South Asia.", latitude: 35.2227, longitude: 72.3526, elevation_meters: nil },
  { name: "Kalam", region: "Swat", description: "A verdant mountain town in upper Swat surrounded by dense forests, waterfalls, and alpine lakes including Mahodand — a launching point for some of the most scenic day trips in the valley.", latitude: 35.4897, longitude: 72.5861, elevation_meters: 2001 },
  { name: "Malam Jabba", region: "Swat", description: "Pakistan's premier ski resort in the Swat hills, offering skiing and snowboarding in winter and year-round chairlift rides with panoramic mountain views.", latitude: 35.1581, longitude: 72.5728, elevation_meters: 2591 },

  # ── Kumrat Region ──────────────────────────────────────
  { name: "Kumrat Valley", region: "Kumrat", description: "A hidden paradise in Upper Dir with lush green meadows, the crystal-clear Panjkora River, and dense pine forests. Home to the otherworldly Jahaz Banda meadow.", latitude: 35.5172, longitude: 72.2275, elevation_meters: 2300 },

  # ── Gilgit District & Surroundings ─────────────────────
  { name: "Gilgit", region: "Gilgit-Baltistan", description: "Capital of Gilgit-Baltistan and main hub for Karakoram travel. Sits at the confluence of the Gilgit and Hunza rivers along the Karakoram Highway.", latitude: 35.9208, longitude: 74.3144, elevation_meters: 1500 },
  { name: "Naltar Valley", region: "Gilgit-Baltistan", description: "Famous for its three brilliantly colored lakes (green, blue, and white), Naltar is a pine-forested alpine wonderland with one of Pakistan's few ski resorts.", latitude: 36.1667, longitude: 74.1833, elevation_meters: 2898 },
  { name: "Rakaposhi Base Camp", region: "Gilgit-Baltistan", description: "Base camp trek to Rakaposhi (7,788m), one of the most beautiful peaks in the Karakoram. Increasingly dramatic close-up views of the mountain's massive glaciated face.", latitude: 36.1500, longitude: 74.5333, elevation_meters: 3200 },
  { name: "Nagar Valley", region: "Gilgit-Baltistan", description: "Home to the Hopar Glacier and traditional Nagar culture, offering quieter mountain experiences and spectacular glacier views without the tourist crowds of Hunza.", latitude: 36.2000, longitude: 74.5833, elevation_meters: 2500 },

  # ── Hunza Valley ───────────────────────────────────────
  { name: "Hunza Valley", region: "Hunza", description: "The crown jewel of Gilgit-Baltistan — a spectacular mountain kingdom with 700-year-old forts, views of 7,000m+ peaks including Rakaposhi, and the legendary hospitality of the Hunzai people.", latitude: 36.3167, longitude: 74.6500, elevation_meters: 2438 },
  { name: "Hussaini Suspension Bridge", region: "Hunza", description: "One of the most thrilling pedestrian bridges in the world, swaying over the turquoise Hunza River near Passu with missing planks making every step an adrenaline-pumping adventure.", latitude: 36.4250, longitude: 74.8583, elevation_meters: 2500 },
  { name: "Borith Lake", region: "Hunza", description: "A serene high-altitude lake near Passu surrounded by the towering Passu Cones and Batura Glacier. A birdwatcher's paradise with mirror-still waters reflecting the Karakoram skyline.", latitude: 36.4583, longitude: 74.8667, elevation_meters: 2600 },
  { name: "Passu Cones", region: "Hunza", description: "One of the most photographed landscapes on the Karakoram Highway — dramatic cathedral-shaped peaks rising sharply, creating an otherworldly skyline iconic to northern Pakistan.", latitude: 36.4881, longitude: 74.8917, elevation_meters: 2500 },
  { name: "Attabad Lake", region: "Hunza", description: "A striking turquoise lake formed in 2010 by a massive landslide. Now offers thrilling boat rides and jet skiing amid submerged trees and dramatic mountain walls.", latitude: 36.3167, longitude: 74.8500, elevation_meters: 2500 },

  # ── Baltistan / Skardu Region ──────────────────────────
  { name: "Skardu", region: "Skardu", description: "Capital of Baltistan and gateway to K2, the world's second-highest peak. Surrounded by cold deserts, turquoise lakes, ancient forts, and some of the most dramatic mountain scenery on the planet.", latitude: 35.2971, longitude: 75.6333, elevation_meters: 2228 },
  { name: "Shangrila Resort", region: "Skardu", description: "Known as 'Heaven on Earth,' Shangrila sits on the shores of Lower Kachura Lake with an iconic airplane-fuselage restaurant and gardens — one of Pakistan's most famous tourist landmarks.", latitude: 35.3333, longitude: 75.6167, elevation_meters: 2500 },
  { name: "Upper Kachura Lake", region: "Skardu", description: "A hidden gem above Shangrila accessible only by a short hike, offering boat rides on crystal-clear turquoise waters so transparent you can see the bottom at 20 feet.", latitude: 35.3500, longitude: 75.6167, elevation_meters: 2500 },
  { name: "Sadpara Lake", region: "Skardu", description: "A natural deep blue lake just south of Skardu town fed by the Sadpara Glacier, offering boat rides with views of the surrounding barren mountains and the Sadpara Dam.", latitude: 35.2667, longitude: 75.6167, elevation_meters: 2636 },
  { name: "Katpana Cold Desert", region: "Skardu", description: "One of the highest cold deserts in the world, featuring vast sand dunes surrounded by snow-capped mountains — a surreal landscape where desert meets Karakoram peaks.", latitude: 35.3083, longitude: 75.5833, elevation_meters: 2226 },
  { name: "Shigar Fort", region: "Skardu", description: "A beautifully restored 17th-century fort converted into a heritage hotel by the Aga Khan Trust. Sits at the gateway to the Baltoro Glacier and K2.", latitude: 35.4264, longitude: 75.7500, elevation_meters: 2260 },
  { name: "Deosai National Park", region: "Skardu", description: "The second-highest plateau in the world at 4,114m. A vast treeless expanse of wildflower meadows teeming with Himalayan brown bears and Sheosar Lake at its heart.", latitude: 35.0897, longitude: 75.4033, elevation_meters: 4114 },

  # ── Hidden Gems ────────────────────────────────────────
  { name: "Astore Valley", region: "Gilgit-Baltistan", description: "A lush green valley between Gilgit and Deosai, the southern gateway to Deosai National Park. Unspoiled alpine meadows, trout-filled streams, and the dramatic Rama Lake.", latitude: 35.3667, longitude: 74.8583, elevation_meters: 2168 },
  { name: "Phander Valley", region: "Gilgit-Baltistan", description: "A serene turquoise lake surrounded by green meadows and pine forests in Ghizer district. Some of the most peaceful and photogenic lake scenery in all of northern Pakistan.", latitude: 36.3833, longitude: 72.5833, elevation_meters: 3100 },
  { name: "Khunjerab Pass", region: "Hunza", description: "The highest paved international border crossing in the world at 4,693m, marking the China-Pakistan frontier on the Karakoram Highway. Spot Marco Polo sheep and stand at the rooftop of the world.", latitude: 36.8500, longitude: 75.4167, elevation_meters: 4693 },
]

place_images = {
  # Galyat Region
  "Mushkpuri Top" => "https://images.unsplash.com/photo-1679170250337-91efc63f4a38?w=1200&q=80",
  "Miranjani Top" => "https://images.unsplash.com/photo-1652260035169-19a650312241?w=1200&q=80",
  # Kaghan Valley
  "Naran" => "https://images.unsplash.com/photo-1572707582365-0ee1c8e71173?w=1200&q=80",
  "Kaghan" => "https://images.unsplash.com/photo-1668061867899-02b4cfa34747?w=1200&q=80",
  "Sharan Forest" => "https://images.unsplash.com/photo-1722599556316-7873764fe301?w=1200&q=80",
  "Shogran" => "https://images.unsplash.com/photo-1572099259127-766d3444c234?w=1200&q=80",
  # Azad Kashmir
  "Neelum Valley" => "https://images.unsplash.com/photo-1598291333322-1b7592118fac?w=1200&q=80",
  "Sharda" => "https://images.unsplash.com/photo-1634276842141-78d5fc34390a?w=1200&q=80",
  "Kel" => "https://images.unsplash.com/photo-1725916691105-5d9831efce08?w=1200&q=80",
  "Arang Kel" => "https://images.unsplash.com/photo-1725916691105-5d9831efce08?w=1200&q=80",
  "Taobat" => "https://images.unsplash.com/photo-1651135135875-a6d458a9462d?w=1200&q=80",
  "Shounter Valley" => "https://images.unsplash.com/photo-1615552713642-73c367c8915c?w=1200&q=80",
  "Leepa Valley" => "https://images.unsplash.com/photo-1723579038258-2a9c9e777509?w=1200&q=80",
  "Ratti Gali Lake" => "https://images.unsplash.com/photo-1712127283283-420c9c80446b?w=1200&q=80",
  # Diamer / Nanga Parbat
  "Fairy Meadows" => "https://images.unsplash.com/photo-1664872749442-01507d1f1c6e?w=1200&q=80",
  "Beyal Camp" => "https://images.unsplash.com/photo-1664872506479-248d07d7d785?w=1200&q=80",
  "Nanga Parbat Base Camp" => "https://images.unsplash.com/photo-1585646688592-0d53a03e2d12?w=1200&q=80",
  # Chitral
  "Chitral Town" => "https://images.unsplash.com/photo-1584562995253-9de7c2a45982?w=1200&q=80",
  "Kalash Valley" => "https://images.unsplash.com/photo-1571089347199-f0600f382311?w=1200&q=80",
  # Swat
  "Swat Valley" => "https://images.unsplash.com/photo-1629146732817-df2e95194367?w=1200&q=80",
  "Kalam" => "https://images.unsplash.com/photo-1634633989623-69c2398928de?w=1200&q=80",
  "Malam Jabba" => "https://images.unsplash.com/photo-1708519749902-75805b36d869?w=1200&q=80",
  # Kumrat
  "Kumrat Valley" => "https://images.unsplash.com/photo-1596464148416-e0916276a9f5?w=1200&q=80",
  # Gilgit & Surroundings
  "Gilgit" => "https://images.unsplash.com/photo-1654116001918-2ed4250cf9db?w=1200&q=80",
  "Naltar Valley" => "https://images.unsplash.com/photo-1675410229007-7f3f86c1a4e6?w=1200&q=80",
  "Rakaposhi Base Camp" => "https://images.unsplash.com/photo-1654598768024-3ab6b9a9dff6?w=1200&q=80",
  "Nagar Valley" => "https://images.unsplash.com/photo-1654116001918-2ed4250cf9db?w=1200&q=80",
  # Hunza
  "Hunza Valley" => "https://images.unsplash.com/photo-1514558427911-8e293bebf18c?w=1200&q=80",
  "Hussaini Suspension Bridge" => "https://images.unsplash.com/photo-1774286673653-9185dbdedbe6?w=1200&q=80",
  "Borith Lake" => "https://images.unsplash.com/photo-1640881193563-b5f0bf20019a?w=1200&q=80",
  "Passu Cones" => "https://images.unsplash.com/photo-1638295381225-c6cd6a467935?w=1200&q=80",
  "Attabad Lake" => "https://images.unsplash.com/photo-1612128952123-88ed13410495?w=1200&q=80",
  # Skardu / Baltistan
  "Skardu" => "https://images.unsplash.com/photo-1672652787237-20f1cf66624e?w=1200&q=80",
  "Shangrila Resort" => "https://images.unsplash.com/photo-1646350375272-104eee57dc77?w=1200&q=80",
  "Upper Kachura Lake" => "https://images.unsplash.com/photo-1678260462226-3380792d52bd?w=1200&q=80",
  "Sadpara Lake" => "https://images.unsplash.com/photo-1627670476256-d333ee59da11?w=1200&q=80",
  "Katpana Cold Desert" => "https://images.unsplash.com/photo-1706030380882-b36f83acf53e?w=1200&q=80",
  "Shigar Fort" => "https://images.unsplash.com/photo-1689799700359-e26f633a4ffa?w=1200&q=80",
  "Deosai National Park" => "https://images.unsplash.com/photo-1610064095022-db1b488c05f1?w=1200&q=80",
  # Hidden Gems
  "Astore Valley" => "https://images.unsplash.com/photo-1752805557869-b6f6d93a8075?w=1200&q=80",
  "Phander Valley" => "https://images.unsplash.com/photo-1675410240817-6db8cb6efbb8?w=1200&q=80",
  "Khunjerab Pass" => "https://images.unsplash.com/photo-1753696252581-3fec5cf1b825?w=1200&q=80",
}

places_data.each do |pd|
  place = Place.create!(
    name: pd[:name],
    region: pd[:region],
    description: pd[:description],
    latitude: pd[:latitude],
    longitude: pd[:longitude],
    elevation_meters: pd[:elevation_meters]
  )
  if place_images[pd[:name]]
    attach_image(place, :cover_image, place_images[pd[:name]], "#{pd[:name].parameterize}_cover.jpg")
  end
end
puts "  Created #{Place.count} places with cover images"

# ═══════════════════════════════════════════════════════════
#  PLACE REVIEWS
# ═══════════════════════════════════════════════════════════
hunza = Place.find_by(name: "Hunza Valley")
fairy = Place.find_by(name: "Fairy Meadows")
skardu = Place.find_by(name: "Skardu")
neelum = Place.find_by(name: "Neelum Valley")
deosai = Place.find_by(name: "Deosai National Park")
passu = Place.find_by(name: "Passu Cones")
naran = Place.find_by(name: "Naran")
kalash = Place.find_by(name: "Kalash Valley")
ratti = Place.find_by(name: "Ratti Gali Lake")

PlaceReview.create!(place: hunza, user: traveler, rating: 5, text: "The most beautiful place I've ever visited. Rakaposhi views from Eagle's Nest are breathtaking!")
PlaceReview.create!(place: hunza, user: traveler2, rating: 5, text: "Incredible hospitality. The apricot season in summer is heavenly. Must visit!")
PlaceReview.create!(place: fairy, user: traveler, rating: 4, text: "The trek up is challenging but so worth it. Camping with Nanga Parbat in view is magical.")
PlaceReview.create!(place: fairy, user: traveler3, rating: 5, text: "Best camping experience of my life. No phone signal — just you and the mountain.")
PlaceReview.create!(place: skardu, user: traveler, rating: 5, text: "Skardu is another world. Upper Kachura Lake is the most peaceful place on earth.")
PlaceReview.create!(place: skardu, user: traveler2, rating: 4, text: "Stunning landscapes everywhere you look. Shangrila is as magical as the name suggests.")
PlaceReview.create!(place: neelum, user: traveler3, rating: 5, text: "Neelum Valley feels like a hidden world. The drive along the river is unforgettable.")
PlaceReview.create!(place: deosai, user: traveler, rating: 5, text: "Deosai is otherworldly. We saw 3 brown bears! Sheosar Lake at dawn is something I'll never forget.")
PlaceReview.create!(place: passu, user: traveler2, rating: 5, text: "Passu Cones at sunset is the most dramatic scenery I've ever witnessed. Worth every hour of the KKH drive.")
PlaceReview.create!(place: naran, user: traveler3, rating: 4, text: "Lake Saif-ul-Malook lives up to the legends. The jeep ride up is an adventure in itself!")
PlaceReview.create!(place: kalash, user: traveler, rating: 5, text: "The Kalash people are incredibly welcoming. Their culture and festivals are unlike anything in the world.")
PlaceReview.create!(place: ratti, user: traveler2, rating: 5, text: "The trek to Ratti Gali is exhausting but the turquoise lake surrounded by peaks makes it all worth it. Absolutely magical!")
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
  u.slug = "nazary-admin"
  u.agency_name_normalized = "nazary admin"
end

# ═══════════════════════════════════════════════════════════
#  PAYMENT ACCOUNTS (Admin-configured)
# ═══════════════════════════════════════════════════════════
PaymentAccount.create!(
  method_type: :jazzcash,
  account_title: "Nazary Payments",
  account_number: "03001234567",
  is_active: true
)
PaymentAccount.create!(
  method_type: :easypaisa,
  account_title: "Nazary Payments",
  account_number: "03009876543",
  is_active: true
)
PaymentAccount.create!(
  method_type: :bank_transfer,
  account_title: "Nazary Travel Pvt Ltd",
  account_number: "PK36MEZN0099120101234567",
  bank_name: "Meezan Bank",
  is_active: true
)
puts "  Created #{PaymentAccount.count} payment accounts"

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
