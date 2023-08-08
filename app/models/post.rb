# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many_attached :images

  validates :title, presence: true, length: { minimum: 3, maximum: 20 }
  validates :body, presence: true, length: { minimum: 5, maximum: 100 }
end
