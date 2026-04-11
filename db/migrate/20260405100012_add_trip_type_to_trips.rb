class AddTripTypeToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :trip_type, :integer, default: 0
    add_column :trips, :is_premium, :boolean, default: false
    add_index :trips, :trip_type
  end
end
