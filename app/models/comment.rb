class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: {minimum: 5, maximum: 100}

  scope :approved, -> { where(approved: true) }
end
