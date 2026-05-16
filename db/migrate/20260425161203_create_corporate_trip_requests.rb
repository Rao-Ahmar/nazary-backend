class CreateCorporateTripRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :corporate_trip_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :company_name, null: false
      t.integer :estimated_people, null: false
      t.string :contact_email
      t.string :contact_phone
      t.text :special_notes
      t.integer :status, null: false, default: 0
      t.text :admin_note
      t.bigint :preferred_planner_id
      t.bigint :linked_trip_id

      t.timestamps
    end

    add_foreign_key :corporate_trip_requests, :users, column: :preferred_planner_id
    add_foreign_key :corporate_trip_requests, :trips, column: :linked_trip_id
    add_index :corporate_trip_requests, [ :user_id, :created_at ]
  end
end
