class AddAdminApprovedToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :admin_approved, :boolean, default: false, null: false
  end
end
