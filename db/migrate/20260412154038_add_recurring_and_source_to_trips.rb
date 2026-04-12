class AddRecurringAndSourceToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :source_trip_id, :bigint, null: true
    add_column :trips, :recurring_enabled, :boolean, default: false, null: false
    add_column :trips, :recurring_rule, :jsonb, null: true

    add_index :trips, :source_trip_id
    add_index :trips, :recurring_enabled
    add_foreign_key :trips, :trips, column: :source_trip_id, on_delete: :nullify
  end
end
