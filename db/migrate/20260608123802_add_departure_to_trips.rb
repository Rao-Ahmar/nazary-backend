class AddDepartureToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :departure, :string
    add_index :trips, :departure, using: :gin, opclass: :gin_trgm_ops, name: "index_trips_on_departure_trigram"
  end
end
