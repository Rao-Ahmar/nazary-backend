class CreateArrangementRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :arrangement_requests do |t|
      t.references :traveler, null: false, foreign_key: { to_table: :users }
      t.text :preferred_destination
      t.text :travel_dates
      t.integer :group_size, null: false, default: 1
      t.decimal :budget_min, precision: 10, scale: 2
      t.decimal :budget_max, precision: 10, scale: 2
      t.text :special_notes
      t.integer :status, null: false, default: 0
      t.references :linked_trip, null: true, foreign_key: { to_table: :trips }

      t.timestamps
    end

    add_index :arrangement_requests, :status
  end
end
