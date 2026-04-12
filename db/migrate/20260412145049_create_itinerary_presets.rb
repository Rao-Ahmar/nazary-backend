class CreateItineraryPresets < ActiveRecord::Migration[8.0]
  def change
    create_table :itinerary_presets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.jsonb :days, null: false, default: []

      t.timestamps
    end

    add_index :itinerary_presets, [ :user_id, :name ], unique: true
  end
end
