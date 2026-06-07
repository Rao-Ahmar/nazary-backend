class AddCachedRatingsToTripsAndUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :cached_average_rating, :decimal, precision: 3, scale: 1, default: 0.0, null: false
    add_column :users, :cached_host_rating, :decimal, precision: 3, scale: 1, default: 0.0, null: false

    reversible do |dir|
      dir.up do
        # Backfill cached_average_rating on trips
        execute <<-SQL
          UPDATE trips SET cached_average_rating = COALESCE(
            (SELECT ROUND(AVG(reviews.rating)::numeric, 1) FROM reviews WHERE reviews.trip_id = trips.id),
            0.0
          )
        SQL

        # Backfill cached_host_rating on users
        # Average of their trips' cached_average_rating (only trips that have reviews)
        execute <<-SQL
          UPDATE users SET cached_host_rating = COALESCE(
            (SELECT ROUND(AVG(trips.cached_average_rating)::numeric, 1)
             FROM trips
             WHERE trips.user_id = users.id AND trips.reviews_count > 0),
            0.0
          )
        SQL
      end
    end
  end
end
