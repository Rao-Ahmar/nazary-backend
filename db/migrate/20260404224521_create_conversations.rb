class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :trip, foreign_key: true

      t.timestamps
    end
  end
end
