class AddAdminApprovedToTripRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :trip_requests, :admin_approved, :boolean, default: false, null: false
  end
end
