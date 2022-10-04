class Event < ApplicationRecord
  belongs_to :user
  has_many :tickets, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 5, maximum: 500 }
  validates :status, inclusion: { in: %w[active inactive] }
  validates :category, inclusion: { in: %w[free paid] }
  validates :start_date, presence: true
  validates :end_date, presence: true

  enum :status, [ :active, :inactive], prefix: true, scopes: true, default: :active
  enum :category, [ :free, :paid], prefix: true, scopes: true, default: :free
end
