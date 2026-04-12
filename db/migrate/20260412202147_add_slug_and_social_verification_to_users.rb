class AddSlugAndSocialVerificationToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :slug, :string
    add_column :users, :agency_name_normalized, :string
    add_column :users, :instagram_verified, :boolean, default: false
    add_column :users, :tiktok_verified, :boolean, default: false
    add_column :users, :social_verified_at, :datetime

    add_index :users, :slug, unique: true, where: "slug IS NOT NULL"
    add_index :users, :agency_name_normalized, unique: true, where: "agency_name_normalized IS NOT NULL"
  end
end
