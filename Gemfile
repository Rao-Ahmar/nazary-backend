source "https://rubygems.org"

gem "rails", "~> 8.0.4"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

# Auth & Security
gem "bcrypt", "~> 3.1"
gem "jwt"
gem "rack-cors"

# JSON Serialization
gem "active_model_serializers"

# Pagination & Search
gem "kaminari"
gem "pg_search"

# Active Storage
gem "image_processing", "~> 2.0"
gem "aws-sdk-s3", require: false

# FCM Push Notifications
gem "googleauth"

# Redis for Action Cable & caching
gem "redis"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
end
