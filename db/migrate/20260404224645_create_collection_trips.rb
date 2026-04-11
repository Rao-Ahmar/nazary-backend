class CreateCollectionTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :collection_trips do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
