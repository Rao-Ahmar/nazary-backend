class VerifyAllSocialAccountsJob < ApplicationJob
  queue_as :default

  def perform
    User.where(role: :planner)
        .where("instagram_url IS NOT NULL OR tiktok_url IS NOT NULL")
        .where.not(slug: nil)
        .find_each do |user|
      VerifySocialAccountsJob.perform_later(user.id)
    end
  end
end
