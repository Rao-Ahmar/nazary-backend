class AddCorporateTripFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :corporate_trips_count, :integer, default: 0, null: false
    add_column :users, :corporate_level, :string, default: "none"
  end
end
