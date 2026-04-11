class CreateTripPreferences < ActiveRecord::Migration[8.0]
  def change
    create_table :trip_preferences do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.decimal :budget_min, precision: 10, scale: 2
      t.decimal :budget_max, precision: 10, scale: 2
      t.integer :preferred_months, array: true, default: []
      t.references :followed_agency, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end

    add_index :trip_preferences, :preferred_months, using: :gin
  end
end
