class RenameChangesToFieldChangesInTripUpdates < ActiveRecord::Migration[8.0]
  def change
    rename_column :trip_updates, :changes, :field_changes
  end
end
