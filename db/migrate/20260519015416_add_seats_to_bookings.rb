class AddSeatsToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :seats, :integer, default: 1, null: false
  end
end
