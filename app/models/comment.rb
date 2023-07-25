# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { minimum: 5, maximum: 100 }

  scope :approved, -> { where(approved: true) }
  scope :not_aprroved, -> { where(approved: false) }
end
