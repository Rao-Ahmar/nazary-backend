class AddAdminVerifiedDeactivatedToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
    add_column :users, :verified, :boolean, default: false, null: false
    add_column :users, :deactivated, :boolean, default: false, null: false
    add_column :users, :city, :string
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_sent_at, :datetime
    add_column :users, :refresh_token, :string

    add_index :users, :password_reset_token, unique: true
    add_index :users, :refresh_token, unique: true
  end
end
