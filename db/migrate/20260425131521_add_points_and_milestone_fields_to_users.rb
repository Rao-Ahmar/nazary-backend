class AddPointsAndMilestoneFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :points, :integer, default: 0, null: false
    add_column :users, :completed_trips_count, :integer, default: 0, null: false
    add_column :users, :surprise_gift_eligible, :boolean, default: false
    add_column :users, :surprise_gift_sent, :boolean, default: false
    add_column :users, :free_trip_eligible, :boolean, default: false
    add_column :users, :free_trip_arranged, :boolean, default: false
  end
end
