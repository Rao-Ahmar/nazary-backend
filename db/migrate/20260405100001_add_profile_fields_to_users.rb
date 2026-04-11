class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :agency_name, :string
    add_column :users, :agency_tagline, :string
    add_column :users, :years_experience, :integer
    add_column :users, :cnic_number, :string
    add_column :users, :profile_completed, :boolean, default: false
    add_column :users, :device_token, :string
    add_column :users, :premium, :boolean, default: false
  end
end
