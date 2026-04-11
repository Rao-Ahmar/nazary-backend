class AddContentUpdatedAtToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :content_updated_at, :datetime
  end
end
