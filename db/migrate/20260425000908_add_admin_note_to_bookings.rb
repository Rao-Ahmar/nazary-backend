class AddAdminNoteToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :admin_note, :text
  end
end
