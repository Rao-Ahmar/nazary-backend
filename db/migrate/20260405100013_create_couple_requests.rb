class CreateCoupleRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :couple_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :partner_name, null: false
      t.string :destination_preference, null: false
      t.string :travel_dates, null: false
      t.string :budget_range, null: false
      t.text :special_requests
      t.integer :status, default: 0, null: false
      t.references :linked_trip, foreign_key: { to_table: :trips }, null: true

      t.timestamps
    end
  end
end
