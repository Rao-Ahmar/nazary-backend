class AddReferralFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :referral_code, :string
    add_column :users, :referred_by_user_id, :bigint

    add_index :users, :referral_code, unique: true
    add_index :users, :referred_by_user_id
    add_foreign_key :users, :users, column: :referred_by_user_id
  end
end
