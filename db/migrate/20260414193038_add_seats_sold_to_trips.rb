class AddSeatsSoldToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :seats_sold, :integer, default: 0, null: false
  end
end
