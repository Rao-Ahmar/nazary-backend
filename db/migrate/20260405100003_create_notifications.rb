class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false
      t.integer :notification_type, default: 4, null: false
      t.jsonb :data, default: {}
      t.boolean :read, default: false

      t.timestamps
    end

    add_index :notifications, [ :user_id, :read ]
    add_index :notifications, :notification_type
  end
end
