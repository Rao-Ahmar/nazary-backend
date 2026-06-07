class AddCounterCachesToTripsAndUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :reviews_count, :integer, default: 0, null: false
    add_column :users, :trips_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up do
        # Backfill reviews_count on trips
        execute <<-SQL
          UPDATE trips SET reviews_count = (
            SELECT COUNT(*) FROM reviews WHERE reviews.trip_id = trips.id
          )
        SQL

        # Backfill trips_count on users (planner's hosted trips)
        execute <<-SQL
          UPDATE users SET trips_count = (
            SELECT COUNT(*) FROM trips WHERE trips.user_id = users.id
          )
        SQL
      end
    end
  end
end
