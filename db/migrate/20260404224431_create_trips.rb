class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :subtitle
      t.text :description, null: false
      t.string :location, null: false
      t.decimal :price, null: false, precision: 10, scale: 2
      t.string :currency, null: false, default: "USD"
      t.string :duration, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :total_seats, null: false
      t.integer :status, null: false, default: 0
      t.text :highlights, array: true, default: []
      t.string :tags, array: true, default: []

      t.timestamps
    end

    add_index :trips, :tags, using: :gin
  end
end
