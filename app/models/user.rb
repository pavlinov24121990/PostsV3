class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts
  has_many :comments

  validates :name, presence: true, length: {minimum: 2, maximum: 20}
  validates :surname, presence: true, length: {minimum: 2, maximum: 20}

  enum role: %i[user admin]

  def full_name
    full_name = "#{name} #{surname}"
  end

end
