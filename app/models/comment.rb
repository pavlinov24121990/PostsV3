class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { minimum: 5, maximum: 100 }

  scope :approved, -> { where(approved: true) }
  scope :not_aprroved, -> { where(approved: false) }
  scope :by_creator, -> (user) { where(user: user) }
  scope :scheduled_for_deletion_at, -> { where(scheduled_for_deletion_at: true) }

end
