class CreateBikeProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :bike_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :bike_model, null: false
      t.integer :bike_cc, null: false
      t.integer :experience_level, default: 0, null: false
      t.text :bio

      t.timestamps
    end
  end
end
