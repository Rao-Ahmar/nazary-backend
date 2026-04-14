class CreateFeedbackSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :feedback_submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject, null: false
      t.text :message, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :feedback_submissions, :status
  end
end
