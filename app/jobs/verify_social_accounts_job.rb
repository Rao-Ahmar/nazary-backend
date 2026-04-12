class VerifySocialAccountsJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user&.planner? && user.slug.present?

    expected_link = "nazary.pk/explore/#{user.slug}"

    instagram_verified = check_bio(user.instagram_url, expected_link)
    tiktok_verified = check_bio(user.tiktok_url, expected_link)

    user.update_columns(
      instagram_verified: instagram_verified,
      tiktok_verified: tiktok_verified,
      social_verified_at: Time.current
    )
  end

  private

  def check_bio(profile_url, expected_link)
    return false if profile_url.blank?

    uri = URI.parse(profile_url)
    response = Net::HTTP.get(uri)
    response.include?(expected_link)
  rescue StandardError
    false
  end
end
