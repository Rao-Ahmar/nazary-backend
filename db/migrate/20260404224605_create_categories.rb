class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :label, null: false
      t.string :icon, null: false

      t.timestamps
    end
  end
end
