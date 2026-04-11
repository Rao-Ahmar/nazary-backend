class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.decimal :amount, null: false, precision: 10, scale: 2

      t.timestamps
    end

    add_index :bookings, [ :trip_id, :user_id ], unique: true
  end
end
