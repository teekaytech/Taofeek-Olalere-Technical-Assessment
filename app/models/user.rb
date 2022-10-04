class User < ApplicationRecord
  has_many :events, dependent: :destroy
  has_many :tickets, dependent: :destroy

  devise :database_authenticatable, :jwt_authenticatable,
         :registerable, jwt_revocation_strategy: JwtDenylist

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true

end
