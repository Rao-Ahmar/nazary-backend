class EnablePgTrgmAndAddTrigramIndexToTrips < ActiveRecord::Migration[8.0]
  def change
    enable_extension "pg_trgm"
    add_index :trips, :title, using: :gin, opclass: :gin_trgm_ops, name: "index_trips_on_title_trgm"
    add_index :trips, :location, using: :gin, opclass: :gin_trgm_ops, name: "index_trips_on_location_trgm"
  end
end
