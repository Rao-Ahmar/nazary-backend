class CreateTripRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :trip_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :planner, null: false, foreign_key: { to_table: :users }
      t.string :destination, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :seats, null: false
      t.string :category
      t.decimal :budget, precision: 10, scale: 2
      t.text :note
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :trip_requests, :status
  end
end
