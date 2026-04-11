class CreatePlaceReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :place_reviews do |t|
      t.references :place, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :text, null: false

      t.timestamps
    end

    add_index :place_reviews, [ :place_id, :user_id ], unique: true
  end
end
