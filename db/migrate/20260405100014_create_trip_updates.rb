class CreateTripUpdates < ActiveRecord::Migration[8.0]
  def change
    create_table :trip_updates do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :editor, null: false, foreign_key: { to_table: :users }
      t.jsonb :changes, default: {}
      t.timestamps
    end
  end
end
