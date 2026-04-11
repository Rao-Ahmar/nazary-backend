class CreateItineraryDays < ActiveRecord::Migration[8.0]
  def change
    create_table :itinerary_days do |t|
      t.references :trip, null: false, foreign_key: true
      t.integer :day, null: false
      t.string :title, null: false
      t.text :desc, null: false

      t.timestamps
    end
  end
end
