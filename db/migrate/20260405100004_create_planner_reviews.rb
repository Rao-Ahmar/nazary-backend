class CreatePlannerReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :planner_reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :planner, null: false, foreign_key: { to_table: :users }
      t.integer :rating, null: false
      t.text :text, null: false

      t.timestamps
    end

    add_index :planner_reviews, [ :user_id, :planner_id ], unique: true
  end
end
