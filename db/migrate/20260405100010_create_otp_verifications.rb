class CreateOtpVerifications < ActiveRecord::Migration[8.0]
  def change
    create_table :otp_verifications do |t|
      t.string :phone_number, null: false
      t.string :code, null: false
      t.datetime :expires_at, null: false
      t.boolean :verified, default: false
      t.integer :attempts, default: 0
      t.timestamps
    end
    add_index :otp_verifications, [:phone_number, :code]
  end
end
