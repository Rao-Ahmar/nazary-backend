class CreatePaymentProofs < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_proofs do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :reference_number, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :method_used, null: false
      t.integer :status, default: 0, null: false
      t.text :admin_note
      t.datetime :verified_at

      t.timestamps
    end

    add_index :payment_proofs, :status
  end
end
