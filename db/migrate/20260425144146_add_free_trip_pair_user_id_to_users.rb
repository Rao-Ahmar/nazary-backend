class AddFreeTripPairUserIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :free_trip_pair_user_id, :bigint
    add_foreign_key :users, :users, column: :free_trip_pair_user_id
  end
end
