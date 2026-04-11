class AddSocialLinksToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :youtube_url, :string
    add_column :users, :instagram_url, :string
    add_column :users, :tiktok_url, :string
    add_column :users, :twitter_url, :string
    add_column :users, :website_url, :string
  end
end
