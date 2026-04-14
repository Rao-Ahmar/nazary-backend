class FeedbackSubmission < ApplicationRecord
  belongs_to :user

  enum :status, { pending: 0, reviewed: 1, resolved: 2 }

  validates :subject, presence: true
  validates :message, presence: true
end
