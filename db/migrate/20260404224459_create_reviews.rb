class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :text, null: false

      t.timestamps
    end

    add_index :reviews, [ :trip_id, :user_id ], unique: true
  end
end
