class CreateCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :collections do |t|
      t.string :title, null: false
      t.string :subtitle

      t.timestamps
    end
  end
end
