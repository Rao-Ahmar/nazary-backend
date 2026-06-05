class AddElevationMetersToPlaces < ActiveRecord::Migration[8.0]
  def change
    add_column :places, :elevation_meters, :integer
  end
end
