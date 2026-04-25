class CreatePointsLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :points_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :points, null: false
      t.string :reason, null: false
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :points_logs, [:user_id, :created_at]
  end
end
