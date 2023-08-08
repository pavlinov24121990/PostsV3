# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one_attached :avatar

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :surname, presence: true, length: { minimum: 2, maximum: 20 }

  enum role: %i[user admin]

  def full_name
    "#{name} #{surname}"
  end
end
