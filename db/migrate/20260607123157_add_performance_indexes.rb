class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :bookings, :status, algorithm: :concurrently, if_not_exists: true
    add_index :trips, :status, algorithm: :concurrently, if_not_exists: true
    add_index :trips, :start_date, algorithm: :concurrently, if_not_exists: true
    add_index :trips, [:status, :start_date], algorithm: :concurrently, if_not_exists: true
  end
end
