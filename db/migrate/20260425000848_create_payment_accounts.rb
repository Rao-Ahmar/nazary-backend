class CreatePaymentAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_accounts do |t|
      t.integer :method_type, null: false
      t.string :account_title, null: false
      t.string :account_number, null: false
      t.string :bank_name
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end

    add_index :payment_accounts, :method_type
    add_index :payment_accounts, :is_active
  end
end
