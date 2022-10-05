class User < ApplicationRecord
  has_many :events, dependent: :destroy
  has_many :tickets, dependent: :destroy

  devise :database_authenticatable, :jwt_authenticatable,
         :registerable, jwt_revocation_strategy: JwtDenylist

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, presence: true, length: { minimum: 6 }, confirmation: true
end
